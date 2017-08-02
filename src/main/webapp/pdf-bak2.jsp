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
    <script src='${ctx_assets}/js/pdfmake.min.js'></script>
    <script src='${ctx_assets}/js/vfs_fonts.js'></script>
    <script>

        var xmldata = parent.xmldata;
        function createPDF(){
            var content=[];
            $(exportconfig).each(function (i){
                if($(this)[0].checked == true){
//                    console.log($(this)[0].checked == true,$(this)[0]);
                    if($(this)[0].pId == "1" && $(this)[0].name == "封面"){

                    }
                    if($(this)[0].pId == "1" && $(this)[0].name == "填表须知"){

                    }
                    if($(this)[0].pId == "1" && $(this)[0].name == "总说明"){

                    }
                    if($(this)[0].pId == "1" && $(this)[0].name == "分部分项工程量清单计价表"){
                        $(xmldata).find("JobList").each(function (i) {
                            var table = [[{text: '#', fontSize: 10}, {text: '项目编码', fontSize: 10}, {text: '项目名称', fontSize: 10}, {text: '项目特征', fontSize: 10},{text:'计数单位', fontSize: 10},{text:'工程数量', fontSize: 10},{text:'综合单价', fontSize: 10},{text:'合价', fontSize: 10},{text:'其中人工费', fontSize: 10}]];
                            $(this).find("BQItem").each(function (j) {
                                table.push([{text:j+1, fontSize: 10},{text:$(this).attr("Code"), fontSize: 10},{text:$(this).attr("Name"), fontSize: 10},{text:$(this).attr("AttrAndWork"), fontSize: 10},{text:$(this).attr("Unit"), fontSize: 10},{text:Number($(this).attr("Quantity")).toFixed(4), fontSize: 10},{text:Number($(this).attr("Rate")).toFixed(2), fontSize: 10},{text:Number($(this).attr("Addup")).toFixed(2), fontSize: 10},{text:$(this).attr("LaborRate"), fontSize: 10}]);
                            });
                            content.push({text: '分部分项工程量清单计价表 ( '+$(this).attr("Name")+' ) ',alignment: 'center', margin: [0, 0, 0, 20]});
                            content.push({
                                table: {
                                    widths: [20, 60, 80,100, 40, 40,40, 40, 40],
                                    headerRows: 1,keepWithHeaderRows: 1,body:table},
//                                layout: {fillColor: function (i, node) { return (i === 0) ?  '#E9E9E9' : null; },hLineColor: function (i, node) {return '#ddd';},vLineColor: function (i, node) {return  '#ddd';} }
                            })
                        });
                        content.push({ text: '', fontSize: 14, bold: true, pageBreak: 'after', margin: [0, 0, 0, 8] });

                    }
                    if($(this)[0].pId == "1" && $(this)[0].name == "措施项目清单计价表(一)"){
                        $(xmldata).find("JobList").each(function (i) {
                            var table = [[{text: '#'}, {text: '项目名称'}, {text: '取费基数'}, {text: '费率'},{text:'金额（元）'}]];
                            $(this).find("MeasureItem1").each(function (j) {
                                table.push([j+1,$(this).attr("Name"),$(this).attr("CostBase"),Number($(this).attr("CostRate")).toFixed(4),$(this).attr("Total")]);
                            });
                            content.push({text: '措施项目清单计价表(一) ( '+$(this).attr("Name")+' ) ',alignment: 'center', margin: [0, 20, 0, 20]});
                            content.push({
                                table: {
                                    widths: ['auto', '*', 'auto','auto', 'auto'],
                                    headerRows: 1,keepWithHeaderRows: 1,body:table},
//                                layout: {fillColor: function (i, node) { return (i === 0) ?  '#E9E9E9' : null; },hLineColor: function (i, node) {return '#ddd';},vLineColor: function (i, node) {return  '#ddd';} }
                            })
                        });
                        content.push({ text: '', fontSize: 14, bold: true, pageBreak: 'after', margin: [0, 0, 0, 8] });
                    }
                    if($(this)[0].pId == "1" && $(this)[0].name == "措施项目清单计价表(二)"){
                        $(xmldata).find("JobList").each(function (i) {
                            var table = [[{text: '#'}, {text: '项目名称'}, {text: '计量单位'}, {text: '工程数量'},{text:'单价（元）'},{text:'合价（元）'},{text:'人工费'}]];
                            $(this).find("MeasureItem2").each(function (j) {
                                table.push([j+1,$(this).attr("Name"),$(this).attr("Unit"),Number($(this).attr("Quantity")).toFixed(4),$(this).attr("Rate"),$(this).attr("Total"),$(this).attr("LaborRate")]);
                            });
                            content.push({text: '措施项目清单计价表(二) ( '+$(this).attr("Name")+' ) ',alignment: 'center', margin: [0, 20, 0, 20]});
                            content.push({
                                table: {
                                    widths: ['auto', '*', 'auto','auto', 'auto','auto', 'auto'],
                                    headerRows: 1,keepWithHeaderRows: 1,body:table},
//                                layout: {fillColor: function (i, node) { return (i === 0) ?  '#E9E9E9' : null; },hLineColor: function (i, node) {return '#ddd';},vLineColor: function (i, node) {return  '#ddd';} }
                            })
                        });
                        content.push({ text: '', fontSize: 14, bold: true, pageBreak: 'after', margin: [0, 0, 0, 8] });
                    }
                    if($(this)[0].pId == "1" && $(this)[0].name == "零星工作项目计价表"){
                        $(xmldata).find("JobList").each(function (i) {
                            var table = [[{text: '#', rowSpan: 2}, {text: '项目名称', rowSpan: 2}, {text: '计量单位', rowSpan: 2}, {text: '数量', rowSpan: 2}, {text: '金额(元)', colSpan: 2},{}],[{}, {}, {},{},{text:'综合单价'},{text:'合价'}]];
                            $(this).find("DayWorkTitle").each(function (j) {
                                table.push([j+1,$(this).attr("Name"),ifnull($(this).attr("Unit")),ifnull($(this).attr("Quantity")),ifnull($(this).attr("Rate")),ifnull($(this).attr("Addup"))]);
                            });
                            content.push({text: '零星工作项目计价表 ( '+$(this).attr("Name")+' ) ',alignment: 'center', margin: [0, 20, 0, 20]});
                            content.push({
                                table: {
                                    widths: [20, 90, 90,90, 90,90],
                                    headerRows: 2,keepWithHeaderRows: 1,body:table}
                            })
                        });
                        content.push({ text: '', fontSize: 14, bold: true, pageBreak: 'after', margin: [0, 0, 0, 8] });
                    }
                    if($(this)[0].pId == "1" && $(this)[0].name == "其他工作项目清单"){
                        $(xmldata).find("JobList").each(function (i) {
                            var table = [[{text: '#'}, {text: '名称'}, {text: '金额'}]];
                            $(this).find("OtherTitle").each(function (j) {
                                table.push([{text:$(this).attr("Name"),colSpan:3}]);
                                $(this).find("OtherItem").each(function (k) {
                                    table.push([k+1,$(this).attr("Name"),$(this).attr("Total")]);
                                });
                            });
                            content.push({text: '其他工作项目清单 ( '+$(this).attr("Name")+' ) ',alignment: 'center', margin: [0, 20, 0, 20]});
                            content.push({
                                table: {
                                    widths: [20,'*','auto'],
                                    headerRows: 1,keepWithHeaderRows: 1,body:table},
//                                layout: {fillColor: function (i, node) { return (i === 0) ?  '#E9E9E9' : null; },hLineColor: function (i, node) {return '#ddd';},vLineColor: function (i, node) {return  '#ddd';} }
                            })
                        });
                        content.push({ text: '', fontSize: 14, bold: true, pageBreak: 'after', margin: [0, 0, 0, 8] });
                    }
                    if($(this)[0].pId == "1" && $(this)[0].name == "规费和税金清单计价表"){
                        $(xmldata).find("JobList").each(function (i) {
                            var table = [[{text: '#'}, {text: '项目名称'}, {text: '取费基数'},{text:'费率（%）'},{text:'金额（元）'}]];
                            $(this).find("LawfeeAndTaxItem").each(function (j) {
                                table.push([j+1,$(this).attr("Name"),$(this).attr("CostBase"),Number($(this).attr("CostRate")).toFixed(4),$(this).attr("Total")]);
                            });
                            content.push({text: '规费和税金清单计价表 ( '+$(this).attr("Name")+' ) ',alignment: 'center', margin: [0, 20, 0, 20]});
                            content.push({
                                table: {
                                    widths: [20,'*','auto','auto','auto'],
                                    headerRows: 1,keepWithHeaderRows: 1,body:table},
//                                layout: {fillColor: function (i, node) { return (i === 0) ?  '#E9E9E9' : null; },hLineColor: function (i, node) {return '#ddd';},vLineColor: function (i, node) {return  '#ddd';} }
                            })
                        });
                        content.push({ text: '', fontSize: 14, bold: true, pageBreak: 'after', margin: [0, 0, 0, 8] });
                    }
                    if($(this)[0].pId == "1" && $(this)[0].name == "主要材料价格表"){
                        $(xmldata).find("JobList").each(function (i) {
                            var table = [[{text: '#'}, {text: '材料编码'}, {text: '材料名称及特殊要求'},{text:'单位'},{text:'数量'},{text:'单价（元）'},{text:'合价（元）'},{text:'备注'}]];
                            $(this).find("ResourceItem").each(function (j) {
                                table.push([j+1,$(this).attr("Code"),ifnull($(this).attr("Name")),ifnull($(this).attr("Unit")),ifnull($(this).attr("Quantity")),ifnull($(this).attr("MarketRate")),ifnull($(this).attr("Addup")),ifnull($(this).attr("remark"))]);
                            });
                            content.push({text: '主要材料价格表 ( '+$(this).attr("Name")+' ) ',alignment: 'center', margin: [0, 20, 0, 20]});
                            content.push({
                                table: {
                                    headerRows: 1,keepWithHeaderRows: 1,body:table},
//                                layout: {fillColor: function (i, node) { return (i === 0) ?  '#E9E9E9' : null; },hLineColor: function (i, node) {return '#ddd';},vLineColor: function (i, node) {return  '#ddd';} }
                            })
                        });
                        content.push({ text: '', fontSize: 14, bold: true, pageBreak: 'after', margin: [0, 0, 0, 8] });
                    }
                    if($(this)[0].pId == "1" && $(this)[0].name == "需评审的材料表"){
                        $(xmldata).find("JobList").each(function (i) {
                            var table = [[{text: '#'} ,{text: '材料名称及特殊要求'},{text:'单位'},{text:'单价（元）'},{text:'总用量'}]];
                            $(this).find("ExamMaterialItem").each(function (j) {
                                table.push([j+1,ifnull($(this).attr("Name")),ifnull($(this).attr("Unit")),ifnull($(this).attr("Rate")),ifnull($(this).attr("Quantity"))]);
                            });
                            content.push({text: '需评审的材料表 ( '+$(this).attr("Name")+' ) ',alignment: 'center', margin: [0, 20, 0, 20]});
                            content.push({
                                table: {
                                    widths: [20,'*','auto','auto','auto'],
                                    headerRows: 1,keepWithHeaderRows: 1,body:table},
//                                layout: {fillColor: function (i, node) { return (i === 0) ?  '#E9E9E9' : null; },hLineColor: function (i, node) {return '#ddd';},vLineColor: function (i, node) {return  '#ddd';} }
                            })
                        });
                        content.push({ text: '', fontSize: 14, bold: true, pageBreak: 'after', margin: [0, 0, 0, 8] });
                    }
                    if($(this)[0].pId == "1" && $(this)[0].name == "分部分项工程工程量清单综合单价计算表"){

                        $(xmldata).find("JobList").each(function (i) {
                            var table = [];
                            $(this).find("BQItem").each(function (j) {
                                table.push([
                                        {colSpan: 2,text: '工程名称'},'',
                                        {colSpan: 6,text: ''},'','','','','',
                                        {colSpan: 2,text: '计量单位'},'',
                                        {colSpan: 2,text: ifnull($(this).attr("Unit"))},''
                                    ],
                                    [
                                        {colSpan: 2,text: '项目编号'},'',
                                        {colSpan: 6,text: ifnull($(this).attr("Code"))},'','','','','',
                                        {colSpan: 2,text: '工程数量'},'',
                                        {colSpan: 2,text: ifnull($(this).attr("Quantity"))},''
                                    ],
                                    [
                                        {colSpan: 2,text: '项目名称'},'',
                                        {colSpan: 6,text: ifnull($(this).attr("Name"))},'','','','','',
                                        {colSpan: 2,text: '综合单价'},'',
                                        {colSpan: 2,text: $(this).attr("Rate")},''
                                    ],
                                    [
                                        '#','定额编号','工程内容','单位','数量','人工费','材料费','机械费','管理费','利润','风险费','小计'
                                    ])
                                $(this).find("NormItem").each(function (k) {
                                    table.push([k+1,$(this).attr("Code"),$(this).attr("Name"),$(this).attr("Unit"),$(this).attr("Quantity"),$(this).attr("LaborRate"),$(this).attr("MaterialRate"),$(this).attr("MachineRate"),$(this).attr("OverheadRate"),$(this).attr("ProfitRate"),$(this).attr("RiskRate"),$(this).attr("Total")]);
                                });
                                table.push([{colSpan:12,text:' ',border: [false, false, false, false]},'','','','','','','','','','','']);
                            });
                            content.push({text: '分部分项工程工程量清单综合单价计算表 ( '+$(this).attr("Name")+' ) ',alignment: 'center', margin: [0, 20, 0, 20]});
                            content.push({
                                table: {
                                    widths: [10, 35, 35,35,35,35,35,35,35,35,35,35],
                                    headerRows: 0,body:table},
//                                layout: {fillColor: function (i, node) { return (i === 0) ?  '#E9E9E9' : null; },hLineColor: function (i, node) {return '#ddd';},vLineColor: function (i, node) {return  '#ddd';} }
                            })
                        });
                        content.push({ text: '', fontSize: 14, bold: true, pageBreak: 'after', margin: [0, 0, 0, 8] });

                    }
                    if($(this)[0].pId == "1" && $(this)[0].name == "措施项目费计算表(一)"){

                    }
                    if($(this)[0].pId == "1" && $(this)[0].name == "措施项目费计算表(二)"){

                    }

                    //==========================

                    if($(this)[0].pId == "2" && $(this)[0].name == "工程量清单招标控制价(标底)"){

                    }
                    if($(this)[0].pId == "2" && $(this)[0].name == "工程量清单报价表(投标)"){

                    }
                    if($(this)[0].pId == "2" && $(this)[0].name == "总说明"){

                    }
                    if($(this)[0].pId == "2" && $(this)[0].name == "投标总价"){

                    }
                    if($(this)[0].pId == "2" && $(this)[0].name == "单项工程造价汇总表"){

                    }
                    if($(this)[0].pId == "2" && $(this)[0].name == "单位工程造价汇总表"){

                    }
                    if($(this)[0].pId == "2" && $(this)[0].name == "分部分项工程量清单计价表"){

                    }
                    if($(this)[0].pId == "2" && $(this)[0].name == "措施项目清单计价表(一)"){

                    }
                    if($(this)[0].pId == "2" && $(this)[0].name == "措施项目清单计价表(二)"){

                    }
                    if($(this)[0].pId == "2" && $(this)[0].name == "零星工作项目计价表"){

                    }
                    if($(this)[0].pId == "2" && $(this)[0].name == "其他工作项目清单"){

                    }
                    if($(this)[0].pId == "2" && $(this)[0].name == "规费和税金清单计价表"){

                    }
                    if($(this)[0].pId == "2" && $(this)[0].name == "主要材料价格表"){

                    }
                    if($(this)[0].pId == "2" && $(this)[0].name == "需评审的材料表"){

                    }
                    if($(this)[0].pId == "2" && $(this)[0].name == "分部分项工程工程量清单综合单价计算表"){

                    }
                    if($(this)[0].pId == "2" && $(this)[0].name == "措施项目费计算表(一)"){

                    }
                    if($(this)[0].pId == "2" && $(this)[0].name == "措施项目费计算表(二)"){

                    }

                }
            });
            return content;
        }

        $(function () {
            $("#filesize").text(parent?Number(parent.filesize/1048576).toFixed(2):0);
            $("#btn_createPDF").click(function () {
                $("#displayOnce").hide();
                $("#hiddenForProcess").show();
                setTimeout(function () {
                    pdfMake.fonts = {
                        Roboto: {
                            normal: 'msyh.ttf',
                            bold: 'msyh.ttf',
                            italics: 'msyh.ttf',
                            bolditalics: 'msyh.ttf'
                        }
                    };
                    var dd = {
                        content: createPDF()
                        ,footer: function(currentPage, pageCount) { return {text:'第 '+ currentPage.toString() + ' 页 / 共 ' + pageCount +' 页',alignment: 'center',margin: [0, 10, 0, 0]}; }
                    }

                    pdfMake.createPdf(dd).getDataUrl(function(outDoc) {
                        document.getElementById('pdfviewer').src = outDoc;
                        $("#hiddenForProcess").hide();
                    });
                },100);
            });
            $.fn.zTree.init($("#treeTwo"), setting, exportconfig);
        });

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
                onClick: function (event, treeId, treeNode, clickFlag) {
//                    console.log("click");
                },
                onCheck:function (e, treeId, treeNode) {
                    changeData(treeNode);
                    $.fn.zTree.init($("#treeTwo"), setting, exportconfig);
                }

            }
        };

        function changeData(treeNode){
            if(treeNode.pId){
                $(exportconfig).each(function (i){
                    if($(this)[0].id == treeNode.id){
                        $(this)[0].ischeck = "1.1.1.1.";
                        $(this)[0].checked = !$(this)[0].checked;
                    }
                    if($(this)[0].pId != treeNode.pId){
                        $(this)[0].checked = false;
                    }
                });
            }
        }

        var exportconfig = [
            { id:1, pId:0, name:"招标", open:true,nocheck:true},
            { id:11, pId:1, name:"封面"},
            { id:12, pId:1, name:"填表须知"},
            { id:13, pId:1, name:"总说明"},
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

            { id:2, pId:0, name:"报价", open:true,nocheck:true},
            { id:221, pId:2, name:"工程量清单招标控制价(标底)"},
            { id:2222, pId:2, name:"工程量清单报价表(投标)"},
            { id:2223, pId:2, name:"总说明"},
            { id:2228, pId:2, name:"投标总价"},
            { id:222, pId:2, name:"单项工程造价汇总表"},
            { id:222, pId:2, name:"单位工程造价汇总表"},
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
    </script>
</head>
<body class="ofh">
<div id="hiddenForProcess" style="position:absolute; width:100%;height:100px;background-color: #0088CC;text-align: center;color:#fff;display:none;"><p style="line-height:100px;font-size:18px;">正在生成pdf文件，数据较多，可能需要一点时间。</p></div>
    <div style="width:25%;height:100%;float: left;;overflow-y:hidden">
        <div style="height:35px;border-bottom:1px solid #d4d4d4;padding-left:10px;"><span style="line-height: 35px;">打印目录配置</span></div>
        <div style="height: 100%;padding-bottom: 145px; ">
            <ul id="treeTwo" class="ztree"></ul>
        </div>
        <div style="position: absolute;width:25%;bottom: 0;left: 0;height:110px;border-top:1px solid #d4d4d4;text-align: center;padding:5px;">
            <button id="btn_createPDF" style="margin:2px 0px;" class="btn-block btn-sm btn-white " type="submit">生成PDF</button>
            <button id="btn_DownLoad" style="margin:2px 0px" class="btn-block btn-sm btn-white " type="submit">下载PDF</button>
            <button id="btn_Upload" style="margin:2px 0px;" class="btn-block btn-sm btn-white " type="submit">上传二维码,并显示到PDF封面</button>
        </div>
    </div>
    <div style="width:75%;height:100%;float: left;border-left:1px solid #d4d4d4">
        <div id="displayOnce" style="text-align: center;padding-top: 160px;font-size: 16px;color:#666">
            <p>点击『生成PDF』实时预览</p>
            <!--<p>当前XML文件大小 <span id="filesize">0</span> M</p>
            <p>注 : XML文件大于3兆时仅提供下载PDF服务 ( 由于本地浏览器内存有限导致 )</p>-->
        </div>
        <iframe class="pdfviewer" id="pdfviewer" name="iframe_pdfviewer" width="100%" height="100%" src="" frameborder="0"  seamless></iframe>
    </div>
</body>

</html>