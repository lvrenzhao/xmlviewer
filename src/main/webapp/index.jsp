<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>XML解析器</title>
    <!-- library list = slimscroll;metismenu;bsfileinput;icheck;jqgrid;laydate;layer;steps;ztree -->
    <jsp:include page="/header.jsp?libs=ztree;jqgrid;layer;" />
    <link href="${ctx_assets}/css/index.css" rel="stylesheet">
    <script src="config.js"></script>
    <script src="index.js"></script>
</head>
<body class="ofh" style="min-width: 800px;">
<div id="idx-header">
    <ul class="nav navbar-nav">
        <li id="menu-open" class="dropdown">
            <a href="javascript:;" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><span class="glyphicon glyphicon-folder-open"></span> &nbsp;文件 <span class="caret"></span></a>
            <ul class="dropdown-menu">
                <li><a href="javascript:;"><input id="openfile" type="file" onclick="javascript:$('#menu-open').removeClass('open')" style="position: absolute;height:30px;width:100%;right: 0;top: 0;opacity: 0" /><i class="fa fa-folder-open-o"></i> 打开 XML / HTB / ZHTB / HZB / ZHZB 成果文件</a></li>
                <li role="separator" class="divider"></li>
                <li><a id="exportPdf" href="javascript:;"><i class="fa fa-file-pdf-o"></i> &nbsp;导出为 PDF 文件</a></li>
            </ul>
        </li>
        <li class="dropdown">
            <a href="javascript:;" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><span class="glyphicon glyphicon-edit"></span> &nbsp;操作 <span class="caret"></span></a>
            <ul class="dropdown-menu">
                <li><a id="checkData" href="javascript:;"><i class="fa fa-circle-thin"></i> 数据检查</a></li>
                <%--<li><a href="javascript:;"><i class="fa fa-database"></i> 将综合单价导入到 mos 系统</a></li>--%>
                <%--<li><a href="javascript:;"><i class="fa fa-cny"></i> &nbsp;调整主材价格</a></li>--%>
            </ul>
        </li>
        <%--<li class="dropdown">--%>
            <%--<a href="javascript:;" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><span class="glyphicon glyphicon-exclamation-sign"></span> &nbsp;检查 <span class="caret"></span></a>--%>
            <%--<ul class="dropdown-menu">--%>
                <%--<li><a href="javascript:;"><i class="fa fa-circle-thin"></i> &nbsp;空数据检查</a></li>--%>
                <%--<li role="separator" class="divider"></li>--%>
                <%--<li><a href="javascript:;"><i class="fa fa-line-chart"></i> 综合单价检查</a></li>--%>
                <%--<li><a href="javascript:;"><i class="fa fa-check-circle-o"></i> &nbsp;工程数量合法性检查</a></li>--%>
            <%--</ul>--%>
        <%--</li>--%>
    </ul>
</div>
<div id="idx-main">
    <div id="idx-main-nav">
        <div id="idx-main-nav-header">
            <h6 style="line-height: 30px;margin: 0px;padding-left: 10px;font-weight: bold;color:#666;width:70%;float:left;"><i class="fa fa-sitemap"></i> 工程结构</h6>
            <div style="width:30%;height:100%;float:left;text-align: right;line-height: 30px;padding-right: 10px;">
                <button id="btn_goLeft" class="btn btn-white btn-xs" type="button" style="color:#666" disabled><i class="fa fa-chevron-left"></i> 返回</button>
            </div>
        </div>
        <div id="idx-main-nav-content">
            <div id="leftTree" style="height:100%;width:219px;background-color:#fff;position: absolute;top:65px;left: 0px;padding-bottom:65px;z-index:999;">
                <ul id="treeDemo" class="ztree"></ul>
            </div>
            <div id="rightTree" style="height:100%;width:219px;background-color:#fff;position:absolute;top:65px;left: 0px;padding-bottom:65px;z-index: 998">
                <ul id="treeTwo" class="ztree"></ul>
            </div>
        </div>
    </div>
    <div id="idx-main-page">
        <div id="idx-main-page-header"><h6 style="line-height: 30px;margin: 0px;padding-left: 10px;font-weight: bold;color:#666"><i class="fa fa-map-signs"></i> <span id="labelFor">数据</span></h6></div>
        <div id="idx-main-page-content">
            <div id="displayOnce" style="text-align: center;padding-top: 160px;font-size: 16px;color:#666">
                <p>点击『文件』『打开本地 xml 文件』开始使用</p>
            </div>
        </div>
    </div>
</div>
<div style="display: none;" id="checkdatabox">
    <ul id="treeThree" class="ztree"></ul>
    <div style="text-align: center;padding:10px">
        <button id="btn_veridata"  class="btn-block btn-sm btn-primary " type="submit">开始检查</button>
    </div>
</div>
</body>
</html>