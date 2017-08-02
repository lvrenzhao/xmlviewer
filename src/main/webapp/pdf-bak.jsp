<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>XML解析器</title>
    <!-- library list = slimscroll;metismenu;bsfileinput;icheck;jqgrid;laydate;layer;steps;ztree -->
    <jsp:include page="/header.jsp?libs=" />
    <link href="${ctx_assets}/css/index.css" rel="stylesheet">

    <script src="${ctx_assets}/js/html2canvas.js"></script>
    <script src="${ctx_assets}/js/html2pdf.js"></script>
    <script src="${ctx_assets}/js/jspdf.min.js"></script>
    <style>
        .a4pageContainer{margin: 0px auto;width: 210mm;}
        .a4page{background-color: #fff;height: 297mm;padding:10px;}
    </style>
    <script>

        $(function () {
            $("#view1").html("<h4 style='text-align: center;'>单项工程汇总表</h4>"+parent.getTableHTML("泰山路 道路工程 - 分部分项工程量清单计价表"));
            $("#view2").html("<h4 style='text-align: center;'>......测试页.......</h4>"+parent.getTableHTML("单项工程汇总表"));
        });

        function test() {

//            var pdf = new jsPDF('p', 'mm', 'a4');
//            pdf.addHTML(document.getElementById('view1'),options,function() {
////                var string = pdf.output('datauristring');
////                $('.preview-pane').attr('src', string);
//                pdf.output('save', "1.pdf");
//            });

            var pdf = new jsPDF('p', 'mm', 'a4');
            var imglist = [];

            html2canvas(document.getElementById('view1'), {
                onrendered: function(canvas) {
                    var img = convertCanvasToImage(canvas);
                    imglist.push(img);
                }
            });

            html2canvas(document.getElementById('view2'), {
                onrendered: function(canvas) {
                    var img = convertCanvasToImage(canvas);
                    imglist.push(img);
                }
            });
            setTimeout(function () {
                console.log(imglist);
                pdf.addImage(imglist[0], 'PNG', 0, 0);
                pdf.addPage();
                pdf.addImage(imglist[1], 'PNG', 0, 0);
                pdf.output('dataurlnewwindow');
                pdf.output('save', "1.pdf");
            },1000)

        }

        function convertCanvasToImage(canvas) {
            var image = new Image();
            image.src = canvas.toDataURL("image/png");
            return image;
        }
    </script>
</head>
<%--<body>--%>
<%--&lt;%&ndash;<div style="background-color: red">1</div>&ndash;%&gt;--%>
<%--</body>--%>

<body style="min-width: 800px;">
<div id="idx-header" style="position: fixed;width:100%;background-color: #323639;border-bottom:1px solid #323639;">
<input type="button" onclick="test()" value="下载pdf文件" style="float: right;margin-top: 5px;margin-right: 10px;" />
</div>
<div style="background-color: #525659;padding-top: 50px;">
    <div id="container" class="a4pageContainer">
        <div id="view1" class="a4page"></div>
        <div class="splitor mt10"></div>
        <div id="view2" class="a4page"></div>
    </div>
</div>
</body>

</html>