<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>XML解析器</title>
    <jsp:include page="/header.jsp?libs=ztree;layer" />
    <link href="${ctx_assets}/css/index.css" rel="stylesheet">
    <script>
        var xmldata = parent.xmldata;
        var type = 0;
        var imgData;
        var noNumberPages = 0;
        var totalprice = parent.total_Amount_calced;//$($(xmldata).find('TenderInfo')[0]).attr("Total");;
        $(function () {
            if(parent.base64img){
                imgData = parent.base64img;
                $("#btn_Upload").text("二维码已上传!")
            }
            $("#menuBtn").click(function() {
                showMenu();
                return false;
            });
            $("#btn_createPDF").click(function () {
                var treeObj=$.fn.zTree.getZTreeObj("treeTwo");
                var   selectedNodes= treeObj.getCheckedNodes(true);
                if(selectedNodes.length == 0){
                    layer.msg("请先勾选打印配置目录.");
                    return;
                }
                $("#displayOnce").hide();
                $("#data").val(JSON.stringify(getPrintModal()))
                $("#noNumberPages").val(noNumberPages)
//                console.log(getPrintModal());
                $("#btn_post_submit").trigger("click");
                layer.msg("因为数据量大，生成PDF可能需要一点时间。");
            });
            $.fn.zTree.init($("#treeTwo"), setting, exportconfig);
            $.fn.zTree.init($("#treeDemo"), setting2, parent.zNodes);
            $("#btn_Upload").click(function () {
                $("#upload_file").trigger("click");
            })
            $("#upload_file").change(function () {
                var file = document.getElementById("upload_file").files[0];
                if(file){
                    r = new FileReader();
                    r.onload = function(){
                        imgData = r.result.substr(r.result.indexOf(",")+1,r.result.length);
                        $("#btn_Upload").text("二维码已上传!")
                    }
                    r.readAsDataURL(file);
                }

            });
        });


        var ifshowed= false;
        function showMenu() {
            if(!ifshowed) {
                $("#menuContent").slideDown("fast");
                $("body").bind("mousedown", onBodyDown);
                ifshowed = true;
            }else{
                hideMenu();
            }
        }
        function hideMenu() {
            if(ifshowed) {
                $("#menuContent").fadeOut("fast");
                $("body").unbind("mousedown", onBodyDown);
                ifshowed=false;
            }
        }
        function onBodyDown(event) {
            if (!(event.target.id == "menuBtn" || event.target.id == "menuContent" || $(event.target).parents("#menuContent").length > 0)) {
                hideMenu();
            }
        }
        function getPrintModal() {
            selectedBuilds = [];
            var buildnodes = $.fn.zTree.getZTreeObj("treeDemo").getNodesByParam('level', 1);
            for(var i = 0 ; buildnodes!=null && i< buildnodes.length ; i++){
                if(buildnodes[i].checked == true) {
                    selectedBuilds.push(buildnodes[i].name)
                }
            }

            noNumberPages = 0;
            var pdfdata=[];
            var projectname = $($(parent.xmldata).find('ConstructProject')[0]).attr("Name");

            $(exportconfig).each(function (j) {
                var nodeItem = $(this)[0];
                if (nodeItem.checked == true && nodeItem.pId == "1" && nodeItem.name == "封面") {
                    noNumberPages++;
                    var noteItem = {nodetype:"封面",catetype:"1",jobname:projectname,data:[]};
                    if(imgData){
                        noteItem.ewm = imgData;
                    }
                    pdfdata.push(noteItem);
                }
                if (nodeItem.checked == true && nodeItem.pId == "1" && nodeItem.name == "填表须知") {
                    noNumberPages++;
                    var noteItem = {nodetype:"填表须知",catetype:"1",jobname:projectname,data:[]};
                    pdfdata.push(noteItem);
                }
                if (nodeItem.checked == true && nodeItem.pId == "2" && nodeItem.name == "工程量清单招标控制价(标底)") {
                    noNumberPages++;
                    var big =convertCurrency(Number(totalprice).toFixed(2));
                    var noteItem = {nodetype:"工程量清单招标控制价(标底)",catetype:"2",jobname:projectname,data:[],totalPrice:Number(totalprice).toFixed(2),totalPriceBig:big};
                    if(imgData){
                        noteItem.ewm = imgData;
                    }
                    pdfdata.push(noteItem);
                }if (nodeItem.checked == true && nodeItem.pId == "2" && nodeItem.name == "工程量清单报价表(投标)") {
                    noNumberPages++;
                    var noteItem = {nodetype:"工程量清单报价表(投标)",catetype:"2",jobname:projectname,data:[]};
                    if(imgData){
                        noteItem.ewm = imgData;
                    }
                    pdfdata.push(noteItem);
                }if (nodeItem.checked == true && nodeItem.pId == "2" && nodeItem.name == "投标总价") {
                    noNumberPages++;var big =convertCurrency(Number(totalprice).toFixed(2));
                    var noteItem = {nodetype:"投标总价",catetype:"2",jobname:projectname,data:[],totalPrice:Number(totalprice).toFixed(2),totalPriceBig:big};
                    if(imgData){
                        noteItem.ewm = imgData;
                    }
                    pdfdata.push(noteItem);
                }
            });

            //插入单项工程汇总
            $(exportconfig).each(function (j) {
                var nodeItem = $(this)[0];
                if (nodeItem.checked == true && nodeItem.pId == "2" && nodeItem.name == "单项工程造价汇总表") {
                    var projectItem = {nodetype:"单项工程造价汇总表",catetype:"2",jobname:projectname,data:[]};
                    var item_Name,total_Amount=0,total_SafetyAndCivilizationMeasuresAmount=0,total_LawfeeAmount=0,total_pbj=0;
                    $(xmldata).find("Building").each(function (i) {
//                        console.log($(this).attr("Name"),$.inArray($(this).attr("Name"), selectedBuilds));
                        if (selectedBuilds.length == 0 || (selectedBuilds.length > 0 && $.inArray($(this).attr("Name"), selectedBuilds) > -1)) {
//                            console.log($(this).attr("Name"));
                            var x_Amount, item_Amount = 0, x_SafetyAndCivilizationMeasuresAmount,
                                item_SafetyAndCivilizationMeasuresAmount = 0, x_LawfeeAmount, item_LawfeeAmount = 0, x_pbj,
                                item_pbj = 0;
                            item_Name = $(this).attr("Name");
                            $(this).find("JobList").each(function (j) {
                                if (selectedJobs.length == 0 || (selectedJobs.length > 0 && $.inArray($(this).attr("Name"), selectedJobs) > -1)) {
                                    x_Amount = $(this).attr("Amount");
                                    item_Amount += isNaN(x_Amount) ? Number(0) : Number(x_Amount);
                                    x_SafetyAndCivilizationMeasuresAmount = $(this).attr("SafetyAndCivilizationMeasuresAmount");
                                    item_SafetyAndCivilizationMeasuresAmount += isNaN(x_SafetyAndCivilizationMeasuresAmount) ? Number(0) : Number(x_SafetyAndCivilizationMeasuresAmount);
                                    x_LawfeeAmount = $(this).attr("LawfeeAmount");
                                    item_LawfeeAmount += isNaN(x_LawfeeAmount) ? Number(0) : Number(x_LawfeeAmount);
                                    x_pbj = Math.round(x_Amount * 100 - x_SafetyAndCivilizationMeasuresAmount * 100 - x_LawfeeAmount * 100) / 100;
                                    item_pbj += isNaN(x_pbj) ? Number(0) : Number(x_pbj);
                                }
                            });
                            total_Amount += isNaN(item_Amount) ? Number(0) : Number(item_Amount);
                            total_SafetyAndCivilizationMeasuresAmount += isNaN(item_SafetyAndCivilizationMeasuresAmount) ? Number(0) : Number(item_SafetyAndCivilizationMeasuresAmount);
                            total_LawfeeAmount += isNaN(item_LawfeeAmount) ? Number(0) : Number(item_LawfeeAmount);
                            total_pbj += isNaN(item_pbj) ? Number(0) : Number(item_pbj);
                            projectItem.data.push(i + 1);
                            projectItem.data.push(item_Name);
                            projectItem.data.push(item_Amount.toFixed(2));
                            projectItem.data.push(item_SafetyAndCivilizationMeasuresAmount.toFixed(2));
                            projectItem.data.push(item_LawfeeAmount.toFixed(2));
                            projectItem.data.push(item_pbj.toFixed(2));
                        }
                    });
                    projectItem.data.push("-");
                    projectItem.data.push("合计");
                    projectItem.data.push(total_Amount.toFixed(2));
                    projectItem.data.push(total_SafetyAndCivilizationMeasuresAmount.toFixed(2));
                    projectItem.data.push(total_LawfeeAmount.toFixed(2));
                    projectItem.data.push(total_pbj.toFixed(2));
                    pdfdata.push(projectItem);
                    return false;
                }
            });

            //==============
            $(xmldata).find("Building").each(function (i) {
                var build = $(this);
                var buildItem = {nodetype:"单位工程造价汇总表",catetype:"2",jobname:$(this).attr("Name"),data:[]};
                if(selectedBuilds.length == 0 || (selectedBuilds.length > 0 && $.inArray($(this).attr("Name"), selectedBuilds) > -1)) {
                    //插入单位工程汇总
                    $(exportconfig).each(function (j) {
                        var nodeItem = $(this)[0];
                        if (nodeItem.checked == true && nodeItem.pId == "2" && nodeItem.name == "单位工程造价汇总表") {

                            var item_Name, item_Amount, total_Amount = 0, item_SafetyAndCivilizationMeasuresAmount,
                                total_SafetyAndCivilizationMeasuresAmount = 0, item_LawfeeAmount,
                                total_LawfeeAmount = 0, item_pbj, total_pbj = 0;
                            $(build).find("JobList").each(function (j) {
                                if (selectedJobs.length==0 || (selectedJobs.length>0 && $.inArray($(this).attr("Name"), selectedJobs) > -1)) {
                                    item_Name = $(this).attr("Name");
                                    item_Amount = $(this).attr("Amount");
                                    total_Amount += isNaN(item_Amount) ? Number(0) : Number(item_Amount);
                                    item_SafetyAndCivilizationMeasuresAmount = $(this).attr("SafetyAndCivilizationMeasuresAmount");
                                    total_SafetyAndCivilizationMeasuresAmount += isNaN(item_SafetyAndCivilizationMeasuresAmount) ? Number(0) : Number(item_SafetyAndCivilizationMeasuresAmount);
                                    item_LawfeeAmount = $(this).attr("LawfeeAmount");
                                    total_LawfeeAmount += isNaN(item_LawfeeAmount) ? Number(0) : Number(item_LawfeeAmount);
                                    item_pbj = Math.round(item_Amount * 100 - item_SafetyAndCivilizationMeasuresAmount * 100 - item_LawfeeAmount * 100) / 100;
                                    total_pbj += isNaN(item_pbj) ? Number(0) : Number(item_pbj);
                                    buildItem.data.push(j + 1);
                                    buildItem.data.push(item_Name);
                                    buildItem.data.push(item_Amount);
                                    buildItem.data.push(item_SafetyAndCivilizationMeasuresAmount);
                                    buildItem.data.push(item_LawfeeAmount);
                                    buildItem.data.push(item_pbj);
                                }
                            });
                            buildItem.data.push("-");
                            buildItem.data.push("合计");
                            buildItem.data.push(total_Amount.toFixed(2));
                            buildItem.data.push(total_SafetyAndCivilizationMeasuresAmount.toFixed(2));
                            buildItem.data.push(total_LawfeeAmount.toFixed(2));
                            buildItem.data.push(total_pbj.toFixed(2));
                            pdfdata.push(buildItem);
                            return false;
                        }
                    });
                }

                $(this).find("JobList").each(function (j) {
                    var objItem;
                    var jobItem = $(this);
                    if (selectedJobs.length==0 || (selectedJobs.length>0 && $.inArray(jobItem.attr("Name"), selectedJobs) > -1)) {
                        $(exportconfig).each(function (j) {
                            var nodeItem = $(this)[0];
                            if (nodeItem.checked == true) {
                                objItem = {
                                    nodetype: nodeItem.name,
                                    catetype: nodeItem.pId,
                                    jobname: $(jobItem).attr("Name"),
                                    data: []
                                };
                                if ($(this)[0].name == "分部分项工程量清单计价表") {
                                    $(jobItem).find("BQItem").each(function (k) {
                                        if (nodeItem.pId == "1") {
                                            objItem.data.push(k + 1);
                                            objItem.data.push(ifnull($(this).attr("Code")));
                                            objItem.data.push(ifnull($(this).attr("Name")));
                                            objItem.data.push(ifnull($(this).attr("AttrAndWork")));
                                            objItem.data.push(ifnull($(this).attr("Unit")));
                                            objItem.data.push(Fix4($(this).attr("Quantity")));
                                            objItem.data.push(" ");
                                            objItem.data.push(" ");
                                            objItem.data.push(" ");
                                        }
                                        if (nodeItem.pId == "2") {
                                            objItem.data.push(k + 1);
                                            objItem.data.push(ifnull($(this).attr("Code")));
                                            objItem.data.push(ifnull($(this).attr("Name")));
                                            objItem.data.push(ifnull($(this).attr("AttrAndWork")));
                                            objItem.data.push(ifnull($(this).attr("Unit")));
                                            objItem.data.push(Fix4($(this).attr("Quantity")));
                                            objItem.data.push(Fix2($(this).attr("Rate")));
                                            objItem.data.push(Fix2($(this).attr("Addup")));
                                            objItem.data.push(ifnull($(this).attr("LaborRate")));
                                        }
                                    });
                                    pdfdata.push(objItem);
                                }
                                if ($(this)[0].name == "措施项目清单计价表(一)") {
                                    $(jobItem).find("MeasureItem1").each(function (k) {
                                        if (nodeItem.pId == "1") {
                                            objItem.data.push(k + 1);
                                            objItem.data.push(ifnull($(this).attr("Name")));
                                            objItem.data.push(" ");
                                            objItem.data.push(" ");
                                            objItem.data.push(" ");
                                        }
                                        if (nodeItem.pId == "2") {
                                            objItem.data.push(k + 1);
                                            objItem.data.push(ifnull($(this).attr("Name")));
                                            objItem.data.push(ifnull($(this).attr("CostBase")));
                                            objItem.data.push(Fix4($(this).attr("CostRate")));
                                            objItem.data.push(ifnull($(this).attr("Total")));
                                        }
                                    });
                                    pdfdata.push(objItem);
                                }
                                if ($(this)[0].name == "措施项目清单计价表(二)") {
                                    $(jobItem).find("MeasureItem2").each(function (k) {
                                        if (nodeItem.pId == "1") {
                                            objItem.data.push(k + 1);
                                            objItem.data.push(ifnull($(this).attr("Name")));
                                            objItem.data.push(ifnull($(this).attr("Unit")));
                                            objItem.data.push(Fix4($(this).attr("Quantity")));
                                            objItem.data.push(" ");
                                            objItem.data.push(" ");
                                            objItem.data.push(" ");
                                        }
                                        if (nodeItem.pId == "2") {
                                            objItem.data.push(k + 1);
                                            objItem.data.push(ifnull($(this).attr("Name")));
                                            objItem.data.push(ifnull($(this).attr("Unit")));
                                            objItem.data.push(Fix4($(this).attr("Quantity")));
                                            objItem.data.push(ifnull($(this).attr("Rate")));
                                            objItem.data.push(ifnull($(this).attr("Total")));
                                            objItem.data.push(ifnull($(this).attr("LaborRate")));
                                        }
                                    });
                                    pdfdata.push(objItem);
                                }
                                if ($(this)[0].name == "零星工作项目计价表") {
                                    $(jobItem).find("DayWorkTitle").each(function (k) {
                                        if (nodeItem.pId == "1") {
                                            objItem.data.push(k + 1);
                                            objItem.data.push(ifnull($(this).attr("Name")));
                                            objItem.data.push(ifnull($(this).attr("Unit")));
                                            objItem.data.push(ifnull($(this).attr("Quantity")));
                                            objItem.data.push(" ");
                                            objItem.data.push(" ");
                                        }
                                        if (nodeItem.pId == "2") {
                                            objItem.data.push(k + 1);
                                            objItem.data.push(ifnull($(this).attr("Name")));
                                            objItem.data.push(ifnull($(this).attr("Unit")));
                                            objItem.data.push(ifnull($(this).attr("Quantity")));
                                            objItem.data.push(ifnull($(this).attr("Rate")));
                                            objItem.data.push(ifnull($(this).attr("Addup")));
                                        }
                                    });
                                    pdfdata.push(objItem);
                                }
                                if ($(this)[0].name == "其他工作项目清单") {
                                    $(jobItem).find("OtherTitle").each(function (f) {
                                        objItem.data.push({name: ifnull($(this).attr("Name"))});
                                        $(this).find("OtherItem").each(function (k) {
                                            if (nodeItem.pId == "1") {
                                                objItem.data.push(k + 1);
                                                objItem.data.push(ifnull($(this).attr("Name")));
                                                objItem.data.push(" ");
                                            }
                                            if (nodeItem.pId == "2") {
                                                objItem.data.push(k + 1);
                                                objItem.data.push(ifnull($(this).attr("Name")));
                                                objItem.data.push(ifnull($(this).attr("Total")));
                                            }
                                        });
                                    });
                                    pdfdata.push(objItem);
                                }
                                if ($(this)[0].name == "规费和税金清单计价表") {
                                    $(jobItem).find("LawfeeAndTaxItem").each(function (k) {
                                        if (nodeItem.pId == "1") {
                                            objItem.data.push(k + 1);
                                            objItem.data.push(ifnull($(this).attr("Name")));
                                            objItem.data.push(" ");
                                            objItem.data.push(" ");
                                            objItem.data.push(" ");
                                        }
                                        if (nodeItem.pId == "2") {
                                            objItem.data.push(k + 1);
                                            objItem.data.push(ifnull($(this).attr("Name")));
                                            objItem.data.push(ifnull($(this).attr("CostBase")));
                                            objItem.data.push(Fix4($(this).attr("CostRate")));
                                            objItem.data.push(ifnull($(this).attr("Total")));
                                        }
                                    });
                                    pdfdata.push(objItem);
                                }
                                if ($(this)[0].name == "主要材料价格表") {
                                    $(jobItem).find("ResourceItem").each(function (k) {
                                        if (nodeItem.pId == "1") {
                                            objItem.data.push(k + 1);
                                            objItem.data.push(ifnull($(this).attr("Code")));
                                            objItem.data.push(ifnull($(this).attr("Name")));
                                            objItem.data.push(ifnull($(this).attr("Unit")));
                                            objItem.data.push(" ");
                                            objItem.data.push(" ");
                                            objItem.data.push(" ");
                                            objItem.data.push(ifnull($(this).attr("remark")));
                                        }
                                        if (nodeItem.pId == "2") {
                                            objItem.data.push(k + 1);
                                            objItem.data.push(ifnull($(this).attr("Code")));
                                            objItem.data.push(ifnull($(this).attr("Name")));
                                            objItem.data.push(ifnull($(this).attr("Unit")));
                                            objItem.data.push(ifnull($(this).attr("Quantity")));
                                            objItem.data.push(ifnull($(this).attr("MarketRate")));
                                            objItem.data.push(ifnull($(this).attr("Addup")));
                                            objItem.data.push(ifnull($(this).attr("remark")));
                                        }
                                    });
                                    pdfdata.push(objItem);
                                }
                                if ($(this)[0].name == "需评审的材料表") {
                                    $(jobItem).find("ExamMaterialItem").each(function (k) {
                                        if (nodeItem.pId == "1") {
                                            objItem.data.push(k + 1);
                                            objItem.data.push(ifnull($(this).attr("Name")));
                                            objItem.data.push(ifnull($(this).attr("Unit")));
                                            objItem.data.push(" ");
                                            objItem.data.push(ifnull($(this).attr("Quantity")));
                                        }
                                        if (nodeItem.pId == "2") {
                                            objItem.data.push(k + 1);
                                            objItem.data.push(ifnull($(this).attr("Name")));
                                            objItem.data.push(ifnull($(this).attr("Unit")));
                                            objItem.data.push(ifnull($(this).attr("Rate")));
                                            objItem.data.push(ifnull($(this).attr("Quantity")));
                                        }
                                    });
                                    pdfdata.push(objItem);
                                }
                                if ($(this)[0].name == "分部分项工程工程量清单综合单价计算表") {
                                    $(jobItem).find("BQItem").each(function (f) {
                                        if (nodeItem.pId == "1") {
                                            objItem.data.push("-Data-Start-");
                                            objItem.data.push("工程名称");
                                            objItem.data.push(projectname);
                                            objItem.data.push("计量单位");
                                            objItem.data.push(ifnull($(this).attr("Unit")));
                                            objItem.data.push("项目编号");
                                            objItem.data.push(ifnull($(this).attr("Code")));
                                            objItem.data.push("工程数量");
                                            objItem.data.push(ifnull($(this).attr("Quantity")));
                                            objItem.data.push("项目名称");
                                            objItem.data.push(ifnull($(this).attr("Name")));
                                            objItem.data.push("综合单价");
                                            objItem.data.push(" ");
                                            $(this).find("NormItem").each(function (k) {
                                                objItem.data.push(k + 1);
                                                objItem.data.push(ifnull($(this).attr("Code")));
                                                objItem.data.push(ifnull($(this).attr("Name")));
                                                objItem.data.push(ifnull($(this).attr("Unit")));
                                                objItem.data.push(ifnull($(this).attr("Quantity")));
                                                objItem.data.push("");
                                                objItem.data.push("");
                                                objItem.data.push("");
                                                objItem.data.push("");
                                                objItem.data.push("");
                                                objItem.data.push("");
                                                objItem.data.push("");
                                            });
                                        }
                                        if (nodeItem.pId == "2") {
                                            objItem.data.push("-Data-Start-");
                                            objItem.data.push("工程名称");
                                            objItem.data.push(projectname);
                                            objItem.data.push("计量单位");
                                            objItem.data.push(ifnull($(this).attr("Unit")));
                                            objItem.data.push("项目编号");
                                            objItem.data.push(ifnull($(this).attr("Code")));
                                            objItem.data.push("工程数量");
                                            objItem.data.push(ifnull($(this).attr("Quantity")));
                                            objItem.data.push("项目名称");
                                            objItem.data.push(ifnull($(this).attr("Name")));
                                            objItem.data.push("综合单价");
                                            objItem.data.push(ifnull($(this).attr("Rate")));
                                            $(this).find("NormItem").each(function (k) {
                                                objItem.data.push(k + 1);
                                                objItem.data.push(ifnull($(this).attr("Code")));
                                                objItem.data.push(ifnull($(this).attr("Name")));
                                                objItem.data.push(ifnull($(this).attr("Unit")));
                                                objItem.data.push(ifnull($(this).attr("Quantity")));
                                                objItem.data.push(ifnull($(this).attr("LaborRate")));
                                                objItem.data.push(ifnull($(this).attr("MaterialRate")));
                                                objItem.data.push(ifnull($(this).attr("MachineRate")));
                                                objItem.data.push(ifnull($(this).attr("OverheadRate")));
                                                objItem.data.push(ifnull($(this).attr("ProfitRate")));
                                                objItem.data.push(ifnull($(this).attr("RiskRate")));
                                                objItem.data.push(ifnull($(this).attr("Total")));
                                            });
                                        }
                                    });
                                    pdfdata.push(objItem);
                                }
                                if ($(this)[0].name == "措施项目费计算表(一)") {
                                    $(jobItem).find("MeasureItem1").each(function (k) {
                                        if (nodeItem.pId == "1") {
                                            objItem.data.push(k + 1);
                                            objItem.data.push(ifnull($(this).attr("Name")));
                                            objItem.data.push('项');
                                            objItem.data.push(" ");
                                            objItem.data.push(" ");
                                            objItem.data.push(" ");
                                        }
                                        if (nodeItem.pId == "2") {
                                            objItem.data.push(k + 1);
                                            objItem.data.push(ifnull($(this).attr("Name")));
                                            objItem.data.push('项');
                                            objItem.data.push(ifnull($(this).attr("BaseAmount")));
                                            objItem.data.push(Fix4($(this).attr("CostRate")));
                                            objItem.data.push(ifnull($(this).attr("Total")));
                                        }
                                    });
                                    pdfdata.push(objItem);
                                }
                                if ($(this)[0].name == "措施项目费计算表(二)") {
                                    $(jobItem).find("MeasureItem2").each(function (f) {
                                        if (nodeItem.pId == "2") {
                                            objItem.data.push([f + 1, ifnull($(this).attr("Name")), ifnull($(this).attr("Unit")), Fix4($(this).attr("Quantity")), ifnull($(this).attr("Rate"))]);
                                            $(this).find("NormItem").each(function (k) {
                                                objItem.data.push(k + 1);
                                                objItem.data.push(ifnull($(this).attr("Code")));
                                                objItem.data.push(ifnull($(this).attr("Name")));
                                                objItem.data.push(ifnull($(this).attr("Unit")));
                                                objItem.data.push(ifnull($(this).attr("Quantity")));
                                                objItem.data.push(ifnull($(this).attr("LaborRate")));
                                                objItem.data.push(ifnull($(this).attr("MaterialRate")));
                                                objItem.data.push(ifnull($(this).attr("MachineRate")));
                                                objItem.data.push(ifnull($(this).attr("OverheadRate")));
                                                objItem.data.push(ifnull($(this).attr("ProfitRate")));
                                                objItem.data.push(ifnull($(this).attr("RiskRate")));
                                                objItem.data.push(ifnull($(this).attr("Total")));
                                            });
                                        }
                                        if (nodeItem.pId == "1") {
                                            objItem.data.push([f + 1, ifnull($(this).attr("Name")), ifnull($(this).attr("Unit")), Fix4($(this).attr("Quantity")), " "]);
                                            $(this).find("NormItem").each(function (k) {
                                                objItem.data.push(k + 1);
                                                objItem.data.push(ifnull($(this).attr("Code")));
                                                objItem.data.push(ifnull($(this).attr("Name")));
                                                objItem.data.push(ifnull($(this).attr("Unit")));
                                                objItem.data.push(ifnull($(this).attr("Quantity")));
                                                objItem.data.push("");
                                                objItem.data.push("");
                                                objItem.data.push("");
                                                objItem.data.push("");
                                                objItem.data.push("");
                                                objItem.data.push("");
                                                objItem.data.push("");
                                            });
                                        }
                                    });
                                    pdfdata.push(objItem);
                                }
                            }
                        });
                    }
                });
            });

            return pdfdata;
        }


        var setting = {
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
                    $.fn.zTree.init($("#treeTwo"), setting, exportconfig);
                }

            }
        };


        var selectedJobs=[];
        var selectedBuilds=[];
        var setting2 = {
            check: {enable: true},
            callback: {
                onClick: function (event, treeId, treeNode, clickFlag) {
                    console.log('click');
                },
                onDoubleClick: function (event, treeId, treeNode, clickFlag) {
                    console.log('double-click');
                },
                onCheck:function (e, treeId, treeNode) {

                    selectedJobs = [];
                    var jobnodes = $.fn.zTree.getZTreeObj("treeDemo").getNodesByParam('level', 2);
                    for(var i = 0 ; jobnodes!=null && i< jobnodes.length ; i++){
                        if(jobnodes[i].checked == true) {
                            selectedJobs.push(jobnodes[i].name)
                        }
                    }

                    if(selectedJobs.length == 0){
                        $("#citySel").val("默认全部生成PDF");
                    }else {
                        $("#citySel").val("共选择" + selectedJobs.length + "个单位工程");
                    }

                }

            }
        };

        function removeByValue(arr, val) {
            for(var i=0; i<arr.length; i++) {
                if(arr[i] == val) {
                    arr.splice(i, 1);
                    break;
                }
            }
        }

        function changeData(treeNode){
            if(treeNode.pId){
                $(exportconfig).each(function (i){
                    if($(this)[0].id == treeNode.id){
                        $(this)[0].checked = !$(this)[0].checked;
                        if($(this)[0].checked){
                            type = $(this)[0].pId;
                        }
                    }
                    if($(this)[0].pId != treeNode.pId){
                        $(this)[0].checked = false;
                    }
                });
            }else{
                var truefalse ;
                $(exportconfig).each(function (i){

                    if($(this)[0].id == treeNode.id){
                        truefalse =  !$(this)[0].checked;
                        $(this)[0].checked =truefalse;
                    }
                    if($(this)[0].pId == treeNode.id){
                        $(this)[0].checked = truefalse;
                    }
                });
            }
        }

        var exportconfig = [
            { id:1, pId:0, name:"招标", open:true},
            { id:11, pId:1, name:"封面"},
            { id:12, pId:1, name:"填表须知"},
//            { id:13, pId:1, name:"总说明"},
            { id:14, pId:1, name:"分部分项工程量清单计价表",type:"1"},
            { id:15, pId:1, name:"措施项目清单计价表(一)",type:"1"},
            { id:16, pId:1, name:"措施项目清单计价表(二)",type:"1"},
            { id:17, pId:1, name:"零星工作项目计价表",type:"1"},
            { id:18, pId:1, name:"其他工作项目清单",type:"1"},
            { id:19, pId:1, name:"规费和税金清单计价表",type:"1"},
            { id:20, pId:1, name:"主要材料价格表",type:"1"},
            { id:21, pId:1, name:"需评审的材料表",type:"1"},
            { id:22, pId:1, name:"分部分项工程工程量清单综合单价计算表",type:"1"},
            { id:23, pId:1, name:"措施项目费计算表(一)",type:"1"},
            { id:24, pId:1, name:"措施项目费计算表(二)",type:"1"},

            { id:2, pId:0, name:"报价", open:true},
            { id:221, pId:2, name:"工程量清单招标控制价(标底)"},
            { id:2222, pId:2, name:"工程量清单报价表(投标)"},
//            { id:2223, pId:2, name:"总说明"},
            { id:2228, pId:2, name:"投标总价"},
            { id:222, pId:2, name:"单项工程造价汇总表"},
            { id:223, pId:2, name:"单位工程造价汇总表"},
            { id:224, pId:2, name:"分部分项工程量清单计价表",type:"2"},
            { id:225, pId:2, name:"措施项目清单计价表(一)",type:"2"},
            { id:226, pId:2, name:"措施项目清单计价表(二)",type:"2"},
            { id:227, pId:2, name:"零星工作项目计价表",type:"2"},
            { id:228, pId:2, name:"其他工作项目清单",type:"2"},
            { id:229, pId:2, name:"规费和税金清单计价表",type:"2"},
            { id:230, pId:2, name:"主要材料价格表",type:"2"},
            { id:231, pId:2, name:"需评审的材料表",type:"2"},
            { id:232, pId:2, name:"分部分项工程工程量清单综合单价计算表",type:"2"},
            { id:233, pId:2, name:"措施项目费计算表(一)",type:"2"},
            { id:234, pId:2, name:"措施项目费计算表(二)",type:"2"}
        ];
        function ifnull(obj) {
            if(!obj){
                return "";
            }else{
                return obj;
            }
        }
        function Fix4(obj) {
            if(!obj){
                return "";
            }else{
                return Number(obj).toFixed(4);
            }
        }
        function Fix2(obj) {
            if(!obj){
                return "";
            }else{
                return Number(obj).toFixed(2);
            }
        }

        function convertCurrency(money) {
            //汉字的数字
            var cnNums = new Array('零', '壹', '贰', '叁', '肆', '伍', '陆', '柒', '捌', '玖');
            //基本单位
            var cnIntRadice = new Array('', '拾', '佰', '仟');
            //对应整数部分扩展单位
            var cnIntUnits = new Array('', '万', '亿', '兆');
            //对应小数部分单位
            var cnDecUnits = new Array('角', '分', '毫', '厘');
            //整数金额时后面跟的字符
            var cnInteger = '整';
            //整型完以后的单位
            var cnIntLast = '元';
            //最大处理的数字
            var maxNum = 999999999999999.9999;
            //金额整数部分
            var integerNum;
            //金额小数部分
            var decimalNum;
            //输出的中文金额字符串
            var chineseStr = '';
            //分离金额后用的数组，预定义
            var parts;
            if (money == '') { return ''; }
            money = parseFloat(money);
            if (money >= maxNum) {
                //超出最大处理数字
                return '';
            }
            if (money == 0) {
                chineseStr = cnNums[0] + cnIntLast + cnInteger;
                return chineseStr;
            }
            //转换为字符串
            money = money.toString();
            if (money.indexOf('.') == -1) {
                integerNum = money;
                decimalNum = '';
            } else {
                parts = money.split('.');
                integerNum = parts[0];
                decimalNum = parts[1].substr(0, 4);
            }
            //获取整型部分转换
            if (parseInt(integerNum, 10) > 0) {
                var zeroCount = 0;
                var IntLen = integerNum.length;
                for (var i = 0; i < IntLen; i++) {
                    var n = integerNum.substr(i, 1);
                    var p = IntLen - i - 1;
                    var q = p / 4;
                    var m = p % 4;
                    if (n == '0') {
                        zeroCount++;
                    } else {
                        if (zeroCount > 0) {
                            chineseStr += cnNums[0];
                        }
                        //归零
                        zeroCount = 0;
                        chineseStr += cnNums[parseInt(n)] + cnIntRadice[m];
                    }
                    if (m == 0 && zeroCount < 4) {
                        chineseStr += cnIntUnits[q];
                    }
                }
                chineseStr += cnIntLast;
            }
            //小数部分
            if (decimalNum != '') {
                var decLen = decimalNum.length;
                for (var i = 0; i < decLen; i++) {
                    var n = decimalNum.substr(i, 1);
                    if (n != '0') {
                        chineseStr += cnNums[Number(n)] + cnDecUnits[i];
                    }
                }
            }
            if (chineseStr == '') {
                chineseStr += cnNums[0] + cnIntLast + cnInteger;
            } else if (decimalNum == '') {
                chineseStr += cnInteger;
            }
            return chineseStr;
        }
    </script>
    <style>

        .menuContent {
            display: none;
            position: absolute;
            top: -200px;
            height: 200px;
            left: 0;
            background: #fff;
            border: 1px solid #ccc !important;
            width: 100%;
            background: #e0e0e0 ;
        }
    </style>
</head>
<body class="ofh">
    <div style="width:25%;height:100%;float: left;;overflow-y:hidden">
        <div style="height:35px;border-bottom:1px solid #d4d4d4;padding-left:10px;"><span style="line-height: 35px;">打印目录配置</span></div>
        <div style="height: 100%;padding-bottom: 165px; ">
            <ul id="treeTwo" class="ztree"></ul>
        </div>
        <div style="position: absolute;width:25%;bottom: 0;left: 0;height:130px;border-top:1px solid #d4d4d4;text-align: center;padding:10px;padding-bottom:5px;">
            <div class="form_item wb100 fl zindex5 " style="padding: 0px">
                <div style="position: relative;">
                    <div class="input-group">
                        <input id="zzid" value="${bean.zzid }" type="hidden" /> <input type="text" class="form-control input-sm bmrequire" retype="text" readonly id="citySel" value="默认全部生成PDF" > <span class="input-group-btn">
                            <button type="button" class="btn btn-primary btn-sm" id="menuBtn">选择单位工程</button>
                        </span>
                    </div>
                    <div id="menuContent" class="menuContent">
                        <ul id="treeDemo" class="ztree"></ul>
                    </div>
                </div>
            </div>
            <button id="btn_createPDF" style="margin:2px 0px;" class="btn-block btn-sm btn-primary " type="submit">生成PDF</button>
            <!--<button id="btn_DownLoad" style="margin:2px 0px" class="btn-block btn-sm btn-white " type="submit">下载PDF</button>-->
            <button id="btn_Upload" style="margin:10px 0px 0px 0px;" class="btn-block btn-sm btn-white " type="submit">上传二维码,并显示到PDF封面</button>
        </div>
    </div>
    <div style="width:75%;height:100%;float: left;border-left:1px solid #d4d4d4">
        <div id="displayOnce" style="text-align: center;padding-top: 160px;font-size: 16px;color:#666">
            <p>点击『生成PDF』实时预览</p>
        </div>
        <iframe class="pdfviewer" id="pdfviewer" name="iframe_pdfviewer" width="100%" height="100%" src="" frameborder="0"  seamless></iframe>
    </div>
<form id="hid_from" name="hid_form" action="${ctx}/pdf.do" method="post" target="iframe_pdfviewer">
    <<input type="hidden" name="data" id="data">
    <<input type="hidden" name="noNumberPages" id="noNumberPages">
    <input type="submit" value="Submit" id="btn_post_submit" />
</form>
<input accept="image/*" name="upimage" id="upload_file" type="file">
</body>

</html>