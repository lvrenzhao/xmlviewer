var xmldata;
var jsonlevelonetree;
var jsonleveltwotree = [{name:"单位工程造价摘要",id:"1"},{name:"分部分项工程量清单计价表"},{name:"措施项目清单计价表(一)"},{name:"措施项目清单计价表(二)"},{name:"零星工作项目计价表"}
                        ,{name:"其他工作项目清单"},{name:"规费和税金清单计价表"},{name:"主要材料价格表"},{name:"需评审的材料表"},{name:"分部分项工程工程量清单综合单价计算表"}
                        ,{name:"措施项目费计算表(一)"},{name:"措施项目费计算表(二)"}];
var zNodes;
var base64img;

var threeNodes = [{ id:1, pId:0, name:"常规检查", open:true,nocheck:true},
    { id:11, pId:1, name:"空数据"},
    { id:12, pId:1, name:"数值不合法(非数字、负值)"}];

var filesize = 0;
var valiNotPassDatas=[];
$(function(){

    $.fn.zTree.init($("#treeThree"), threeSetting, threeNodes); //加载第二个树

    var xmlurl = getUrlParam('xmlurl');
    var ewmurl = getUrlParam('ewmurl');
    if(xmlurl){
        $.ajax({
            type: 'GET',
            async : false,
            url: xmlurl ,
            success: function (data) {
                xmldata = data;
                $("#displayOnce").remove();
                loadtree();//加载树,并启动树各项事件，以及默认触发第一个节点点击事件。
                $.fn.zTree.init($("#treeTwo"), setting, jsonleveltwotree); //加载第二个树
            },
            dataType: "xml"
        });
    }
    if(ewmurl){
        // console.log(ewmurl)
        convertImgToBase64(ewmurl, function(base64Img){
            base64img = base64Img.substr(base64Img.indexOf(",")+1,base64Img.length)
        });
    }
    $('#openfile').change(function () {
        var file = document.getElementById("openfile").files[0];
        if(!file){return;}
        filesize = file.size;
        var reader = new FileReader();
        //将文件以文本形式读入页面
        reader.readAsText(file);
        reader.onload=function(f){
            try{
                xmldata = $.parseXML(this.result);
                valiNotPassDatas = [];
                $("#displayOnce").remove();
                goLeft();
                loadtree();//加载树,并启动树各项事件，以及默认触发第一个节点点击事件。
                $.fn.zTree.init($("#treeTwo"), setting, jsonleveltwotree); //加载第二个树
            }catch(err){
                alert("未能正确解析，可能是由于文件非XML格式，或XML内容不正确引起。");
            }
        }
    });
    $("#exportPdf").click(function () {
            layer.open({
                type : 2,
                shift : 5,
                title : '导出为PDF文件',
                shadeClose : false,
                shade : 0.3,
                area : [ '100%', '100%' ],
                content : "pdf.jsp",
                cancel : function(index) {
                    layer.close(index);
                }
            });
    });
    var indexoflayer ;
    $("#checkData").click(function () {
        indexoflayer = layer.open({
            type : 1,
            shift : 5,
            title : '数据检查',
            shadeClose : false,
            shade : 0.3,
            area : [ '380px', '200px' ],
            content : $("#checkdatabox"),
            cancel : function(index) {
                layer.close(index);
            }
        });
    });

    $("#btn_veridata").click(function(){
        valiNotPassDatas = [];
        var checkblank = false;
        var checkvalidata = false;
        $(threeNodes).each(function (j) {
            var nodeItem = $(this)[0];
            if (nodeItem.checked == true && nodeItem.name == "空数据") {
                checkblank = true;
            }
            if (nodeItem.checked == true && nodeItem.name == "数值不合法(非数字、负值)") {
                checkvalidata = true;
            }
        });
        $(xmldata).find("JobList").each(function (j) {
            var job = $(this);
            var jobno = $(this).attr("JobNo");
            $(jsonleveltwotree).each(function (k) {
                var node=$(this)[0];
                var row_index = node.name.replace("(","").replace(")","")+jobno;
                //目前观测其余数据均不会出现空数据情况，仅零星工作项目计价表会出现，所以再次仅检查此表格。
                if(node.name == "零星工作项目计价表"){
                    var NAItem = {jobno:jobno,type:node.name,rows:[]};
                    if(checkblank){
                        $(job).find("DayWorkTitle").each(function (l) {
                            if (!$(this).attr("Unit") || !$(this).attr("Quantity") || !$(this).attr("Rate") || !$(this).attr("Addup")) {
                                NAItem.rows.push(row_index+(l+1));
                            }
                        });
                        if(NAItem.rows.length>0){
                            valiNotPassDatas.push(NAItem);
                        }
                    }
                }
            });
        });
        for(var i =0 ; i<valiNotPassDatas.length;i++){
            for(var j = 0 ;j<loopNodes.length;j++){
                if(loopNodes[j].jb == valiNotPassDatas[i].jobno){
                    $("#"+loopNodes[j].idx).css("color","red");
                }
            }
        }
        goLeft();
        layer.msg("检查完毕!");
        parent.layer.close(indexoflayer);
    });

    $("#btn_goLeft").click(function(){goLeft();});
});

//_name:表格名称，_level:表格层级(从0起始,3代表是第二个tree)
var parent_name = "";
var parent_jb="";
function loadGrid(_name,_level,treeNode){
    if(_level == 0){
        $("#labelFor").text("单项工程汇总表");
        $("#idx-main-page-content").html(getTableHTML("单项工程汇总表"));
    }else if(_level == 1){
        $("#labelFor").text(_name+" - 单位工程汇总表");
        $("#idx-main-page-content").html(getTableHTML(_name+" - 单位工程汇总表"));
    }else if(_level == 2){
        $("#labelFor").text(_name);
        parent_name = _name;
        goRight();
        var zTreeTwo = $.fn.zTree.getZTreeObj("treeTwo");//获取ztree对象
        var node = zTreeTwo.getNodeByParam('id', 1);//获取id为1的点
        zTreeTwo.selectNode(node);//选择点
        zTreeTwo.setting.callback.onClick(null, zTreeTwo.setting.treeId, node);//调用事件
        $("#treeTwo .node_name").css("color","black");
        if(treeNode.jb){
            parent_jb = treeNode.jb;
            for (var i =0;valiNotPassDatas!=null&&i<valiNotPassDatas.length;i++){
                if(valiNotPassDatas[i].jobno == treeNode.jb){
                    var idx = 0;
                    for(var j =0 ; j<jsonleveltwotree.length;j++){
                        if(jsonleveltwotree[j].name == valiNotPassDatas[i].type){
                            idx = j;
                            break;
                        }
                    }
                    $("#treeTwo_"+(idx+1)+"_span").css("color","red");
                }
            }
        }
    }else if(_level == 3){
        //根据_name加载表格。
        $("#labelFor").text(parent_name+" - "+_name);
        $("#idx-main-page-content").html(getTableHTML(parent_name+" - "+_name));

        for (var i =0;valiNotPassDatas!=null&&i<valiNotPassDatas.length;i++){
            if(valiNotPassDatas[i].jobno == parent_jb && _name == valiNotPassDatas[i].type){
                // console.log(valiNotPassDatas[i].rows)
                for(var j = 0; j<valiNotPassDatas[i].rows.length;j++){
                    // console.log($("#"+valiNotPassDatas[i].rows[j]))
                    $("#ROW_"+valiNotPassDatas[i].rows[j]).css("background-color","#FFFACD");
                }
                break;
            }
        }
    }
}

//导出pdf，可增加caption便于显示。
function getTableHTML(_name) {
    // console.log(_name);
    var domStr = '<table class="table table-bordered table-condensed table-hover"><thead>${thead}</thead><tbody>${tbody}</tbody></table>';
    var headstr="";
    var bodystr="";
    if(_name.indexOf('-') >= 0){
        var nodename = _name.substring(0,_name.lastIndexOf('-')-1);
        var type = _name.substring(_name.lastIndexOf('-')+2,_name.length);
        headstr = configObject["header_"+type];
        // console.log("单项工程汇总表" , type)
        if("单位工程汇总表" == type){
            $(xmldata).find("Building").each(function (i) {
                // console.log($(this).attr("Name") == nodename);
                if($(this).attr("Name") == nodename){
                    var item_Name,item_Amount,total_Amount=0,item_SafetyAndCivilizationMeasuresAmount,total_SafetyAndCivilizationMeasuresAmount=0,item_LawfeeAmount,total_LawfeeAmount=0,item_pbj,total_pbj=0;
                    $(this).find("JobList").each(function (j) {
                        item_Name = $(this).attr("Name");
                        item_Amount = $(this).attr("Amount");
                        total_Amount += isNaN(item_Amount)?Number(0):Number(item_Amount);
                        item_SafetyAndCivilizationMeasuresAmount = $(this).attr("SafetyAndCivilizationMeasuresAmount");
                        total_SafetyAndCivilizationMeasuresAmount += isNaN(item_SafetyAndCivilizationMeasuresAmount)?Number(0):Number(item_SafetyAndCivilizationMeasuresAmount);
                        item_LawfeeAmount = $(this).attr("LawfeeAmount");
                        total_LawfeeAmount += isNaN(item_LawfeeAmount)?Number(0):Number(item_LawfeeAmount);
                        item_pbj = Math.round(item_Amount * 100 - item_SafetyAndCivilizationMeasuresAmount * 100 - item_LawfeeAmount * 100) / 100;
                        total_pbj += isNaN(item_pbj)?Number(0):Number(item_pbj);
                        bodystr += "<tr><td>"+(j+1)+"</td><td>"+item_Name+"</td><td style='text-align: right'>"+item_Amount+"</td><td style='text-align: right'>"+item_SafetyAndCivilizationMeasuresAmount+"</td><td style='text-align: right'>"+item_LawfeeAmount+"</td><td style='text-align: right'>"+item_pbj+"</td></tr>";
                    });
                    bodystr += "<tr><td>-</td><td>合计</td><td style='text-align: right'>"+total_Amount.toFixed(2)+"</td><td style='text-align: right'>"+total_SafetyAndCivilizationMeasuresAmount.toFixed(2)+"</td><td style='text-align: right'>"+total_LawfeeAmount.toFixed(2)+"</td><td style='text-align: right'>"+total_pbj.toFixed(2)+"</td></tr>";

                    return false;
                }
            });
        }else if("单位工程造价摘要" == type){
            $(xmldata).find("JobList").each(function (i) {
                var jobno = $(this).attr("JobNo");
                if($(this).attr("Name") == nodename){
                    $(this).find("SummaryItem").each(function (j) {
                        bodystr += "<tr id='ROW_"+type.replace("(","").replace(")","")+jobno+(j+1)+"'><td>"+(j+1)+"</td><td>"+ifnull($(this).attr("Name"))+"</td><td style='text-align: right'>"+$(this).attr("Total")+"</td></tr>"
                    });
                    return false;
                }
            });
        }else if("分部分项工程量清单计价表" == type){
            $(xmldata).find("JobList").each(function (i) {
                var jobno = $(this).attr("JobNo");
                if($(this).attr("Name") == nodename){
                    $(this).find("BQItem").each(function (j) {
                        bodystr += "<tr id='ROW_"+type.replace("(","").replace(")","")+jobno+(j+1)+"'><td>"+(j+1)+"</td><td>"+$(this).attr("Code")+"</td><td>"+$(this).attr("Name")+"</td><td>"
                            +$(this).attr("AttrAndWork")+"</td><td>"+$(this).attr("Unit")+"</td><td style='text-align: right'>"+Number($(this).attr("Quantity")).toFixed(4)+
                            "</td><td style='text-align: right'>"+Number($(this).attr("Rate")).toFixed(2)+"</td><td style='text-align: right'>"+Number($(this).attr("Addup")).toFixed(2)+"</td><td style='text-align: right'>"+$(this).attr("LaborRate")+
                            "</td></tr>"
                    });
                    return false;
                }
            });
        }else if("措施项目清单计价表(一)" == type){
            $(xmldata).find("JobList").each(function (i) {
                var jobno = $(this).attr("JobNo");
                if($(this).attr("Name") == nodename){
                    $(this).find("MeasureItem1").each(function (j) {
                        bodystr += "<tr id='ROW_"+type.replace("(","").replace(")","")+jobno+(j+1)+"'><td>"+(j+1)+"</td><td>"+$(this).attr("Name")+"</td><td style='text-align: right'>"+$(this).attr("CostBase")+"</td><td style='text-align: right'>"+Number($(this).attr("CostRate")).toFixed(4)+"</td><td style='text-align: right'>"+$(this).attr("Total")+"</td></tr>"
                    });
                    return false;
                }
            });
        }else if("措施项目清单计价表(二)" == type){
            $(xmldata).find("JobList").each(function (i) {
                var jobno = $(this).attr("JobNo");
                if($(this).attr("Name") == nodename){
                    $(this).find("MeasureItem2").each(function (j) {
                        bodystr += "<tr id='ROW_"+type.replace("(","").replace(")","")+jobno+(j+1)+"'><td>"+(j+1)+"</td><td>"+$(this).attr("Name")+"</td><td>"+$(this).attr("Unit")+"</td><td style='text-align: right'>"+Number($(this).attr("Quantity")).toFixed(4)+"</td><td style='text-align: right'>"+$(this).attr("Rate")+"</td><td style='text-align: right'>"+$(this).attr("Total")+"</td><td style='text-align: right'>"+$(this).attr("LaborRate")+"</td></tr>"
                    });
                    return false;
                }
            });
        }else if("零星工作项目计价表" == type){
            $(xmldata).find("JobList").each(function (i) {
                var jobno = $(this).attr("JobNo");
                if($(this).attr("Name") == nodename){
                    $(this).find("DayWorkTitle").each(function (j) {
                        bodystr += "<tr id='ROW_"+type.replace("(","").replace(")","")+jobno+(j+1)+"'><td>"+(j+1)+"</td><td>"+ifnull($(this).attr("Name"))+"</td><td>"+ifnull($(this).attr("Unit"))+"</td><td style='text-align: right'>"+ifnull($(this).attr("Quantity"))+"</td><td style='text-align: right'>"+ifnull($(this).attr("Rate"))+"</td><td style='text-align: right'>"+ifnull($(this).attr("Addup"))+"</td></tr>"
                    });
                    return false;
                }
            });
        }else if("其他工作项目清单" == type){
            $(xmldata).find("JobList").each(function (i) {
                var jobno = $(this).attr("JobNo");
                if($(this).attr("Name") == nodename){
                    $(this).find("OtherTitle").each(function (j) {
                        bodystr += "<tr><td colspan='3'>"+ifnull($(this).attr("Name"))+"</td></tr>"
                        $(this).find("OtherItem").each(function (k) {
                            bodystr += "<tr id='ROW_"+type.replace("(","").replace(")","")+jobno+(j+1)+"'><td>"+(k+1)+"</td><td>"+$(this).attr("Name")+"</td><td style='text-align: right'>"+$(this).attr("Total")+"</td></tr>";
                        });
                    });
                    return false;
                }
            });
        }else if("规费和税金清单计价表" == type){
            $(xmldata).find("JobList").each(function (i) {
                var jobno = $(this).attr("JobNo");
                if($(this).attr("Name") == nodename){
                    $(this).find("LawfeeAndTaxItem").each(function (j) {
                        // bodystr += "<tr><td colspan='5'>"+ifnull($(this).attr("Name"))+"</td></tr>"
                        // $(this).find("OtherItem").each(function (j) {
                            bodystr += "<tr id='ROW_"+type.replace("(","").replace(")","")+jobno+(j+1)+"'><td>"+(j+1)+"</td><td>"+$(this).attr("Name")+"</td><td style='text-align: right'>"+$(this).attr("CostBase")+"</td><td style='text-align: right'>"+Number($(this).attr("CostRate")).toFixed(4)+"</td><td style='text-align: right'>"+$(this).attr("Total")+"</td></tr>";
                        // });
                    });
                    return false;
                }
            });
        }else if("主要材料价格表" == type){
            $(xmldata).find("JobList").each(function (i) {
                var jobno = $(this).attr("JobNo");
                if($(this).attr("Name") == nodename){
                    $(this).find("ResourceItem").each(function (j) {
                        bodystr += "<tr id='ROW_"+type.replace("(","").replace(")","")+jobno+(j+1)+"'><td>"+(j+1)+"</td><td>"+ifnull($(this).attr("Code"))+"</td><td>"+ifnull($(this).attr("Name"))+"</td><td>"+ifnull($(this).attr("Unit"))+"</td><td style='text-align: right'>"+ifnull($(this).attr("Quantity"))+"</td><td style='text-align: right'>"+ifnull($(this).attr("MarketRate"))+"</td><td style='text-align: right'>"+ifnull($(this).attr("Addup"))+"</td><td>"+ifnull($(this).attr("remark"))+"</td></tr>";
                    });
                    return false;
                }
            });
        }else if("需评审的材料表" == type){
            $(xmldata).find("JobList").each(function (i) {
                var jobno = $(this).attr("JobNo");
                if($(this).attr("Name") == nodename){
                    $(this).find("ExamMaterialItem").each(function (j) {
                        bodystr += "<tr id='ROW_"+type.replace("(","").replace(")","")+jobno+(j+1)+"'><td>"+(j+1)+"</td><td>"+ifnull($(this).attr("Name"))+"</td><td>"+ifnull($(this).attr("Unit"))+"</td><td style='text-align: right'>"+ifnull($(this).attr("Rate"))+"</td><td style='text-align: right'>"+ifnull($(this).attr("Quantity"))+"</td></tr>";
                    });
                    return false;
                }
            });
        }else if("分部分项工程工程量清单综合单价计算表" == type){
            var projectname = $($(xmldata).find('ConstructProject')[0]).attr("Name");
            $(xmldata).find("JobList").each(function (i) {
                if($(this).attr("Name") == nodename){
                    $(this).find("BQItem").each(function (j) {
                        bodystr += "<tr><td>工程名称</td><td>"+projectname+"</td><td>计量单位</td><td>"+ifnull($(this).attr("Unit"))+"</td></tr>";
                        bodystr += "<tr><td>项目编号</td><td>"+ifnull($(this).attr("Code"))+"</td><td>工程数量</td><td>"+ifnull($(this).attr("Quantity"))+"</td></tr>";
                        bodystr += "<tr><td>项目名称</td><td>"+ifnull($(this).attr("Name"))+"</td><td>综合单价</td><td>"+$(this).attr("Rate")+"</td></tr>";
                        // bodystr += "<tr><td>"+(j+1)+"</td><td>"+ifnull($(this).attr("Code"))+"</td><td>"+ifnull($(this).attr("Name"))+"</td><td>"+ifnull($(this).attr("Unit"))+"</td><td>"+ifnull($(this).attr("Quantity"))+"</td><td>"+ifnull($(this).attr("Rate"))+"</td></tr>";
                        bodystr += "<tr><td colspan='6' style='padding:0px 0px 20px 0px;'><table class='table table-bordered table-condensed table-hover'><thead><tr><th>#</th><th>定额编号</th><th>工程内容</th><th>单位</th><th>数量</th><th>人工费</th><th>材料费</th><th>机械费</th><th>管理费</th><th>利润</th><th>风险费</th><th>小计</th></tr></thead><tbody>";
                        $(this).find("NormItem").each(function (k) {
                            bodystr += "<tr><td>"+(k+1)+"</td><td>"+$(this).attr("Code")+"</td><td>"+$(this).attr("Name")+"</td><td>"+$(this).attr("Unit")+"</td><td style='text-align: right'>"+$(this).attr("Quantity")+"</td><td style='text-align: right'>"+$(this).attr("LaborRate")+"</td><td style='text-align: right'>"+$(this).attr("MaterialRate")+"</td><td style='text-align: right'>"+$(this).attr("MachineRate")+"</td><td style='text-align: right'>"+$(this).attr("OverheadRate")+"</td><td style='text-align: right'>"+$(this).attr("ProfitRate")+"</td><td style='text-align: right'>"+$(this).attr("RiskRate")+"</td><td style='text-align: right'>"+$(this).attr("Total")+"</td></tr>";
                        });
                        bodystr += "</tbody></table></td></tr>";
                    });
                    return false;
                }
            });
        }else if("措施项目费计算表(一)" == type){
            $(xmldata).find("JobList").each(function (i) {
                var jobno = $(this).attr("JobNo");
                if($(this).attr("Name") == nodename){
                    $(this).find("MeasureItem1").each(function (j) {
                        bodystr += "<tr id='ROW_"+type.replace("(","").replace(")","")+jobno+(j+1)+"'><td>"+(j+1)+"</td><td>"+$(this).attr("Name")+"</td><td>项</td><td style='text-align: right'>"+$(this).attr("BaseAmount")+"</td><td style='text-align: right'>"+Number($(this).attr("CostRate")).toFixed(4)+"</td><td style='text-align: right'>"+$(this).attr("Total")+"</td></tr>"
                    });
                    return false;
                }
            });
        }else if("措施项目费计算表(二)" == type){
            $(xmldata).find("JobList").each(function (i) {
                if ($(this).attr("Name") == nodename) {
                    $(this).find("MeasureItem2").each(function (j) {
                        bodystr += "<tr><td>" + (j + 1) + "</td><td>" + $(this).attr("Name") + "</td><td>" + $(this).attr("Unit") + "</td><td style='text-align: right'>" + Number($(this).attr("Quantity")).toFixed(4) + "</td><td style='text-align: right'>" + $(this).attr("Rate") + "</td></tr>"

                        bodystr += "<tr><td colspan='5' style='padding:0px 0px 20px 0px;'><table class='table table-bordered table-condensed table-hover'><thead><tr><th>#</th><th>定额编号</th><th>工程内容</th><th>单位</th><th>数量</th><th>人工费</th><th>材料费</th><th>机械费</th><th>管理费</th><th>利润</th><th>风险费</th><th>小计</th></tr></thead><tbody>";
                        $(this).find("NormItem").each(function (k) {
                            bodystr += "<tr><td>"+(k+1)+"</td><td>"+$(this).attr("Code")+"</td><td>"+$(this).attr("Name")+"</td><td>"+$(this).attr("Unit")+"</td><td style='text-align: right'>"+$(this).attr("Quantity")+"</td><td style='text-align: right'>"+$(this).attr("LaborRate")+"</td><td style='text-align: right'>"+$(this).attr("MaterialRate")+"</td><td style='text-align: right'>"+$(this).attr("MachineRate")+"</td><td style='text-align: right'>"+$(this).attr("OverheadRate")+"</td><td style='text-align: right'>"+$(this).attr("ProfitRate")+"</td><td style='text-align: right'>"+$(this).attr("RiskRate")+"</td><td style='text-align: right'>"+$(this).attr("Total")+"</td></tr>";
                        });
                        bodystr += "</tbody></table></td></tr>";
                    });
                    return false;
                }
            });
        }
    }else{
        //单项工程汇总表
        headstr = configObject["header_"+_name];
        var item_Name,total_Amount=0,total_SafetyAndCivilizationMeasuresAmount=0,total_LawfeeAmount=0,total_pbj=0;
        $(xmldata).find("Building").each(function (i) {
            var x_Amount,item_Amount=0,x_SafetyAndCivilizationMeasuresAmount,item_SafetyAndCivilizationMeasuresAmount=0,x_LawfeeAmount,item_LawfeeAmount=0,x_pbj,item_pbj=0;
            item_Name = $(this).attr("Name");
            $(this).find("JobList").each(function (j) {
                x_Amount = $(this).attr("Amount");
                item_Amount += isNaN(x_Amount)?Number(0):Number(x_Amount);
                x_SafetyAndCivilizationMeasuresAmount = $(this).attr("SafetyAndCivilizationMeasuresAmount");
                item_SafetyAndCivilizationMeasuresAmount += isNaN(x_SafetyAndCivilizationMeasuresAmount)?Number(0):Number(x_SafetyAndCivilizationMeasuresAmount);
                x_LawfeeAmount = $(this).attr("LawfeeAmount");
                item_LawfeeAmount += isNaN(x_LawfeeAmount)?Number(0):Number(x_LawfeeAmount);
                x_pbj = Math.round(x_Amount * 100 - x_SafetyAndCivilizationMeasuresAmount * 100 - x_LawfeeAmount * 100) / 100;
                item_pbj += isNaN(x_pbj)?Number(0):Number(x_pbj);
            });
            total_Amount += isNaN(item_Amount)?Number(0):Number(item_Amount);
            total_SafetyAndCivilizationMeasuresAmount += isNaN(item_SafetyAndCivilizationMeasuresAmount)?Number(0):Number(item_SafetyAndCivilizationMeasuresAmount);
            total_LawfeeAmount += isNaN(item_LawfeeAmount)?Number(0):Number(item_LawfeeAmount);
            total_pbj += isNaN(item_pbj)?Number(0):Number(item_pbj);
            bodystr += "<tr><td>"+(i+1)+"</td><td>"+item_Name+"</td><td style='text-align: right'>"+item_Amount.toFixed(2)+"</td><td style='text-align: right'>"+item_SafetyAndCivilizationMeasuresAmount.toFixed(2)+"</td><td style='text-align: right'>"+item_LawfeeAmount.toFixed(2)+"</td><td style='text-align: right'>"+item_pbj.toFixed(2)+"</td></tr>";
        });
        total_Amount_calced = total_Amount.toFixed(2);
        bodystr += "<tr><td>-</td><td>合计</td><td style='text-align: right'>"+total_Amount.toFixed(2)+"</td><td style='text-align: right'>"+total_SafetyAndCivilizationMeasuresAmount.toFixed(2)+"</td><td style='text-align: right'>"+total_LawfeeAmount.toFixed(2)+"</td><td style='text-align: right'>"+total_pbj.toFixed(2)+"</td></tr>";
    }
    domStr = domStr.replace("${thead}",headstr);
    domStr = domStr.replace("${tbody}",bodystr);
    return domStr;
}

var total_Amount_calced = 0;

function ifnull(obj) {
    if(!obj){
        return "";
    }else{
        return obj;
    }
}
function vericell(obj) {
    return obj;
}
var loopNodes = [];
function loadtree(){
    jsonlevelonetree = {};
    jsonlevelonetree.id="1";
    jsonlevelonetree.name=$($(xmldata).find('ConstructProject')[0]).attr("Name");
    jsonlevelonetree.open="true";
    jsonlevelonetree.children = [];
    var _idx = 2;
    $(xmldata).find("Building").each(function (i) {
        var dxgc_item = {};
        dxgc_item.name = $(this).attr("Name");
        dxgc_item.open="true";
        dxgc_item.children = [];
        _idx++;
        $(this).find("JobList").each(function (j) {
            var dwgc_item = {};
            dwgc_item.name = $(this).attr("Name");
            dwgc_item.jb = $(this).attr("JobNo");
            loopNodes.push({idx:"treeDemo_"+_idx+"_span",jb:$(this).attr("JobNo")})
            dxgc_item.children.push(dwgc_item);
            _idx++;
        });
        jsonlevelonetree.children.push(dxgc_item)
    });
    zNodes=[jsonlevelonetree];
    $.fn.zTree.init($("#treeDemo"), setting, zNodes);
    var zTree = $.fn.zTree.getZTreeObj("treeDemo");//获取ztree对象
    var node = zTree.getNodeByParam('id', 1);//获取id为1的点
    zTree.selectNode(node);//选择点
    zTree.setting.callback.onClick(null, zTree.setting.treeId, node);//调用事件
}

var setting = {
    callback: {
        onClick: function (event, treeId, treeNode, clickFlag) {
            //加载表格
            var tl = treeId == "treeTwo"?3:treeNode.level;
            loadGrid(treeNode.name,tl,treeNode)
        }
    }
};
var threeSetting = {
    check: {
        enable: true
    },
    data: {
        simpleData: {
            enable: true
        }
    },
    callback: {
        onCheck:function (e, treeId, treeNode) {
            changeData(treeNode);
            $.fn.zTree.init($("#treeThree"), threeSetting, threeNodes);
        }
    }
};

function changeData(treeNode){
    if(treeNode.pId){
        $(threeNodes).each(function (i){
            if($(this)[0].id == treeNode.id){
                $(this)[0].checked = !$(this)[0].checked;
            }
        });
    }
}

function goLeft(){
    $("#leftTree").animate({left:"0px"});
    $("#btn_goRight").removeAttr("disabled");
    $("#btn_goLeft").attr({"disabled":"disabled"});
}

function goRight(){
    $("#btn_goRight").attr({"disabled":"disabled"});
    $("#btn_goLeft").removeAttr("disabled");
    $("#leftTree").animate({left:"-220px"});
}

function gridWidth() {
    return $("#idx-main-page-content").outerWidth() - 2;
}

function gridHeight() {
    return $("#idx-main-page-content").outerHeight() - 105 ;
}

function getUrlParam(name) {
    var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
    var r = window.location.search.substr(1).match(reg);  //匹配目标参数
    if (r != null) return unescape(r[2]); return null; //返回参数值
}

function convertImgToBase64(url, callback, outputFormat){
    var canvas = document.createElement('CANVAS'),
        ctx = canvas.getContext('2d'),
        img = new Image;
    img.crossOrigin = 'Anonymous';
    img.onload = function(){
        canvas.height = img.height;
        canvas.width = img.width;
        ctx.drawImage(img,0,0);
        var dataURL = canvas.toDataURL(outputFormat || 'image/png');
        callback.call(this, dataURL);
        canvas = null;
    };
    img.src = url;
}
