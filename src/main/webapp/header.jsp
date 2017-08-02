<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" scope="application" />
<c:set var="ctx_assets" value="${pageContext.request.contextPath}/assets" scope="application" />
<c:set var="ctx_assets_3rd" value="${pageContext.request.contextPath}/assets/thirdparty" scope="application" />
<c:set var="v" value="1.0.0.1" scope="application" />

<script language="JavaScript" type="text/JavaScript">
    var app = {ctx:"${ctx}"}
</script>

<link href="${ctx_assets_3rd}/bootstrap/css/bootstrap.min.css?v=${v}" rel="stylesheet">
<link href="${ctx_assets_3rd}/font-awesome/css/font-awesome.min.css?v=${v}" rel="stylesheet">


<c:if test='${fn:indexOf(param["libs"], "bsfileinput") >= 0}'><link href="${ctx_assets_3rd}/bootstrap-fileinput/css/fileinput.min.css?v=${v}" rel="stylesheet"></c:if>
<c:if test='${fn:indexOf(param["libs"], "chosen") >= 0}'><link href="${ctx_assets_3rd}/chosen/chosen.css?v=${v}" rel="stylesheet"></c:if>
<c:if test='${fn:indexOf(param["libs"], "icheck") >= 0}'><link href="${ctx_assets_3rd}/icheck/custom.css?v=${v}" rel="stylesheet"></c:if>
<c:if test='${fn:indexOf(param["libs"], "jqgrid") >= 0}'><link href="${ctx_assets_3rd}/jqgrid/ui.jqgrid-bootstrap.css?v=${v}" rel="stylesheet"></c:if>
<c:if test='${fn:indexOf(param["libs"], "ztree") >= 0}'><link href="${ctx_assets_3rd}/ztree/zTreeStyle.css?v=${v}" rel="stylesheet"><link href="${ctx_assets_3rd}/ztree/metroStyle/metroStyle.css?v=${v}" rel="stylesheet"></c:if>
<c:if test='${fn:indexOf(param["libs"], "summernote") >= 0}'><link href="${ctx_assets_3rd}/summernote/summernote.css?v=${v}" rel="stylesheet"><link href="${ctx_assets_3rd}/summernote/summernote-bs3.css?v=${v}" rel="stylesheet"></c:if>


<!-- mergeTo:style.min.css -->
<link href="${ctx_assets}/css/a1_global-reset.css" rel="stylesheet">
<link href="${ctx_assets}/css/a2_global-class.css" rel="stylesheet">
<link href="${ctx_assets}/css/b_component-grid.css" rel="stylesheet">
<link href="${ctx_assets}/css/b_component-form.css" rel="stylesheet">
<link href="${ctx_assets}/css/b_component-btn.css" rel="stylesheet">
<link href="${ctx_assets}/css/b_component-benmobox.css" rel="stylesheet">
<link href="${ctx_assets}/css/b_component-window.css" rel="stylesheet">
<link href="${ctx_assets}/css/b_component-tab.css" rel="stylesheet">
<link href="${ctx_assets}/css/b_component-slide.css" rel="stylesheet">
<link href="${ctx_assets}/css/b_component-timeline.css" type="text/css" rel="stylesheet" />
<!-- mergeTo -->

<script src="${ctx_assets_3rd}/jquery/jquery.min.js?v=${v}"></script>
<script src="${ctx_assets_3rd}/bootstrap/js/bootstrap.min.js?v=${v}"></script>

<c:if test='${fn:indexOf(param["libs"], "bsfileinput") >= 0}'><script src="${ctx_assets_3rd}/bootstrap-fileinput/fileinput.min.js?v=${v}"></script><script src="${ctx_assets_3rd}/bootstrap-fileinput/zh.js?v=${v}"></script></c:if>
<c:if test='${fn:indexOf(param["libs"], "chosen") >= 0}'><script src="${ctx_assets_3rd}/chosen/chosen.jquery.js?v=${v}"></script></c:if>
<c:if test='${fn:indexOf(param["libs"], "slimscroll") >= 0}'><script src="${ctx_assets_3rd}/slimscroll/jquery.slimscroll.min.js?v=${v}"></script></c:if>
<c:if test='${fn:indexOf(param["libs"], "icheck") >= 0}'><script src="${ctx_assets_3rd}/icheck/icheck.min.js?v=${v}"></script></c:if>
<c:if test='${fn:indexOf(param["libs"], "jqgrid") >= 0}'><script src="${ctx_assets_3rd}/jqgrid/i18n/grid.locale-cn.js?v=${v}"></script><script src="${ctx_assets_3rd}/jqgrid/jquery.jqGrid.min.js?v=${v}"></script></c:if>
<c:if test='${fn:indexOf(param["libs"], "laydate") >= 0}'><script src="${ctx_assets_3rd}/laydate/laydate.js?v=${v}"></script></c:if>
<c:if test='${fn:indexOf(param["libs"], "layer") >= 0}'><script src="${ctx_assets_3rd}/layer/layer.min.js?v=${v}"></script></c:if>
<c:if test='${fn:indexOf(param["libs"], "ztree") >= 0}'><script src="${ctx_assets_3rd}/ztree/jquery.ztree.all.min.js?v=${v}"></script></c:if>
<c:if test='${fn:indexOf(param["libs"], "echarts") >= 0}'><script src="${ctx_assets_3rd}/echarts/echarts.simple.min.js?v=${v}"></script></c:if>
<c:if test='${fn:indexOf(param["libs"], "metismenu") >= 0}'><script src="${ctx_assets_3rd}/metisMenu/jquery.metisMenu.js?v=${v}"></script></c:if>
<c:if test='${fn:indexOf(param["libs"], "summernote") >= 0}'><script src="${ctx_assets_3rd}/summernote/summernote.min.js?v=${v}"></script><script src="${ctx_assets_3rd}/summernote/summernote-zh-CN.js?v=${v}"></script></c:if>


<script src="${ctx_assets}/js/jsutils.js?v=${v}"></script>