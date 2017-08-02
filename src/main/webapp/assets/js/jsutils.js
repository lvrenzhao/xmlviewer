/** jqgrid 全局设置样式主体为bootstrp设置* */
if ($ && $.jgrid) {
    $.jgrid.defaults.styleUI = 'Bootstrap';
}
/** jquery全局扩展方法在此定义* */
(function($) {
    // 获取浏览器参数
    $.getUrlParam = function(name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
        var r = window.location.search.substr(1).match(reg);
        if (r != null)
            return unescape(r[2]);
        return null;
    }
})(jQuery);

function timeformatter11(cellvalue, options, rowObject) {
    if (cellvalue != null && cellvalue != '') {
        return cellvalue.substring(0, 11);
    } else {
        return "";
    }
}

function timeformatter16(cellvalue, options, rowObject) {
    if (cellvalue != null && cellvalue != '') {
        return cellvalue.substring(0, 16);
    } else {
        return "";
    }
}

function timeformatter19(cellvalue, options, rowObject) {
    if (cellvalue != null && cellvalue != '') {
        return cellvalue.substring(0, 19);
    } else {
        return "";
    }
}

/*
 * firstitem 为第一个tab的子容器 secitem 为第二个tab的自容器
 */
function doubletab(firstitem, secitem) {
    $(firstitem).on('click', function() {
        var curindex = $(this).index();
        secitem.eq(curindex).addClass("active").siblings().removeClass("active");
    })
};

function checkEndTime(startTime, endTime) {
    var _state;
    var _startval = startTime.val();
    var start = new Date(_startval.replace("-", "/").replace("-", "/"));
    var _endval = endTime.val();
    var end = new Date(_endval.replace("-", "/").replace("-", "/"));
    if (_startval != "" && _endval != "") {
        startTime.removeClass("border-red");
        if (end < start) {
            endTime.addClass("border-red");
            _state = false;
        } else {
            endTime.removeClass("border-red");
            _state = true;
        }
    } else {
        startTime.addClass("border-red");
        endTime.addClass("border-red");
        _state = false;
    }
    return _state;
};

// 统一验证，retype的值为“text"为输入框，retype的值为“select"为下拉选择框，retype的值为“number"为数字输入框
function checkmyform(ele, checkhide) {
    var state = true;
    var _this, _thisval, _thistype, _thisform;
    _thisform = ele.find(".bmrequire");
    $(_thisform).each(function() {
        _this = $(this);
        if (checkhide || !_this.is(':hidden')) {
            _thisval = _this.val();
            _thistype = $(this).attr("retype");
            var reg = /^\d+(?=\.{0,1}\d+$|$)/;// 正则验证只能是数字和小数点
            if (_thistype == "text") {
                if (_thisval == "") {
                    _this.addClass("border-red");
                    state = false;
                } else {
                    _this.removeClass("border-red");
                }
            } else if (_thistype == "select") {
                if (_thisval == "") {
                    _this.addClass("border-red");
                    state = false;
                } else {
                    _this.removeClass("border-red");
                }
            } else if (_thistype == "number") {
                if (_thisval != "") {
                    if (!reg.test(_thisval)) {
                        state = false;
                        _this.addClass("border-red");
                    } else {
                        _this.removeClass("border-red");
                    }
                } else {
                    state = false;
                    _this.addClass("border-red");
                }
            } else if (_thistype == "multiselect") {
                if (_thisval != null) {
                    _this.closest(".form_item ").find(".chosen-container .chosen-choices").removeClass("border-red");
                } else {
                    state = false;
                    _this.closest(".form_item ").find(".chosen-container .chosen-choices").addClass("border-red");
                }
            } else if (_thistype == "datatime") {
                if (_thisval == "") {
                    state = false;
                    _this.addClass("border-red");

                } else {
                    _this.removeClass("border-red");
                }
            } else if (_thistype == "files") {
                if (_thisval == "") {
                    state = false;
                    _this.closest(".form_item").find(".kv-fileinput-caption").addClass("border-red");

                } else {
                    _this.closest(".form_item").find(".kv-fileinput-caption").removeClass("border-red");
                }
            }else if (_thistype == "fileview") {
                if (_thisval == "") {
                    state = false;
                    _this.closest(".form_item").find(".file-drop-zone").addClass("border-red");

                } else {
                    _this.closest(".form_item").find(".file-drop-zone").removeClass("border-red");
                }
            }
        }
    })
    return state;
};

function checking(_thistype, _thisval, _this) {
    var state = true;
    var reg = /^\d+(?=\.{0,1}\d+$|$)/;// 正则验证只能是数字和小数点
    if (_thistype == "text") {
        if (_thisval == "") {
            _this.addClass("border-red");
            state = false;
        } else {
            _this.removeClass("border-red");
        }
    } else if (_thistype == "select") {
        if (_thisval == "") {
            _this.addClass("border-red");
            state = false;
        } else {
            _this.removeClass("border-red");
        }
    } else if (_thistype == "number") {
        if (_thisval != "") {
            if (!reg.test(_thisval)) {
                state = false;
                _this.addClass("border-red");
            } else {
                _this.removeClass("border-red");
            }
        } else {
            state = false;
            _this.addClass("border-red");
        }
    } else if (_thistype == "multiselect") {
        if (_thisval != null) {
            _this.closest(".form_item ").find(".chosen-container .chosen-choices").removeClass("border-red");
        } else {
            state = false;
            _this.closest(".form_item ").find(".chosen-container .chosen-choices").addClass("border-red");
        }
    } else if (_thistype == "datatime") {
        if (_thisval == "") {
            state = false;
            _this.addClass("border-red");

        } else {
            _this.removeClass("border-red");
        }
    } else if (_thistype == "files") {
        if (_thisval == "") {
            state = false;
            _this.closest(".form_item").find(".kv-fileinput-caption").addClass("border-red");

        } else {
            _this.closest(".form_item").find(".kv-fileinput-caption").removeClass("border-red");
        }
    }else if (_thistype == "fileview") {
        if (_thisval == "") {
            state = false;
            _this.closest(".form_item").find(".file-drop-zone").addClass("border-red");

        } else {
            _this.closest(".form_item").find(".file-drop-zone").removeClass("border-red");
        }
    }

    return state;
}

//判断当前验证失败的第一个form元素，获取位置，滚动页面到相应位置，并获取焦点
function formremian(fatherele,sonele){
    var _this,_index,_position;
    $(".bmrequire").each(function(){
        _this=$(this);
        if(_this.hasClass("border-red")){
            _this.focus();
            _position=_this.closest(sonele).position().top;
            $(fatherele).scrollTop(_position);
            return false;
        }
    })
};

// 统一验证失去焦点事件
function checkmyblur() {
    var _this, _thisval, _thistype;
    var reg = /^\d+(?=\.{0,1}\d+$|$)/;// 正则验证只能是数字和小数点
    $(".bmrequire").on('blur', function() {
        _this = $(this);
        _thisval = $(this).val();
        _thistype = $(this).attr("retype");
        if (_thistype == "text") {
            if (_thisval == "") {
                _this.addClass("border-red");
            } else {
                _this.removeClass("border-red");
            }
        } else if (_thistype == "number") {
            if (_thisval != "") {
                if (!reg.test(_thisval)) {
                    _this.addClass("border-red");
                } else {
                    _this.removeClass("border-red");
                }
            } else {
                _this.addClass("border-red");
            }
        } else if (_thistype == "datatime") {
            if (_thisval == "") {
                _this.addClass("border-red");
            } else {
                _this.removeClass("border-red");
            }
        }

    });

    $(".checknum").on('blur', function() {
        _this = $(this);
        _thisval = $(this).val();
        if (_thisval != "") {
            if (!reg.test(_thisval)) {
                _this.val("");
                _this.focus();
            }
        }
    });

    $(".bmrequire[retype='number'],.checknum").keypress(function(event) {
        var eventObj = event || e;
        var keyCode = eventObj.keyCode || eventObj.which;
        if ((keyCode < 48 || keyCode > 57) && keyCode != 8 && keyCode != 46) {
            return false;
        } else {
            return true;
        }
    }).focus(function() {
        // 禁用输入法
        this.style.imeMode = 'disabled';
    }).bind("paste", function() {
        // 获取剪切板的内容
        var clipboard = window.clipboardData.getData("Text");
        if (/^\d+$/.test(clipboard))
            return true;
        else
            return false;
    });
    $(".bmrequire[retype='select']").change(function() {
        _this = $(this);
        _thisval = $(this).val();
        if (_thisval != "") {
            _this.removeClass("border-red");
        } else {
            _this.addClass("border-red");
        }
    });
};

// 关闭父级弹窗
function closebox() {
    var index = parent.layer.getFrameIndex(window.name); // 获取窗口索引
    parent.layer.close(index);
}

function clearform(ele) {
    ele.find("input[type='text'],select,textarea").val("");
    ele.find("input[type='file']").each(function() {
        $(this).fileinput("clear");
    });
}

// 获取时间差
function GetDateDiff(endTime) {
    var intDiff = datediff(endTime);
    if (intDiff > 0) {
        var day = Math.floor(intDiff / (60 * 60 * 24));
        var hour = Math.floor(intDiff / (60 * 60)) - (day * 24);
        var minute = Math.floor(intDiff / 60) - (day * 24 * 60) - (hour * 60);
        // second = Math.floor(intDiff) - (day * 24 * 60 * 60) - (hour * 60 *
        // 60) - (minute * 60);
        if (minute >= 30) {
            if (hour != 23) {
                hour++;
            } else {
                day++;
                hour = 0;
            }
        }
        if (day > 0) {
            if (hour > 0) {
                return day + "天" + hour + "小时";
            } else {
                return day + "天";
            }
        } else {
            if (hour > 0) {
                return hour + "小时";
            } else {
                var str = '<span class="label label-danger">已到期</span>';
                return str;
            }
        }
    } else {
        var str = '<span class="label label-danger">已到期</span>';
        return str;
    }
};

function datediff(endTime) {
    var startTime = getnowtime();
    // 将xxxx-xx-xx的时间格式，转换为 xxxx/xx/xx的格式
    startTime = startTime.replace(/-/g, "/");
    endTime = endTime.replace(/-/g, "/");
    var sTime = new Date(startTime); // 开始时间
    var eTime = new Date(endTime); // 结束时间
    return parseInt((eTime.getTime() - sTime.getTime()) / parseInt(1000));// 秒
}

// 获取当前时间
function getnowtime() {
    var d = new Date(), str = '';
    str += d.getFullYear() + '-';
    str += d.getMonth() + 1 + '-';
    str += d.getDate() + ' ';
    str += d.getHours() + ':';
    str += d.getMinutes() + ':';
    str += d.getSeconds();
    return str;
};

// 设置码表下拉框
function initDictSelect(parentids, selectid) {
    $.ajax({
        type : 'POST',
        url : ahcourt.ctx + '/setting/dict/getByParent.do',
        datatype : 'json',
        async : false,
        data : {
            "parent_id" : parentids
        },
        success : function(data) {
            //console.log(data);
            if (data && data.length > 0) {
                $(selectid).each(function() {
                    var initid = $(this).attr('initdata');
                    var html = '<option value="">--请选择--</option>';
                    for (var i = 0; i < data.length; i++) {
                        html += '<option ' + (initid == data[i].zdbh ? 'selected="selected" ' : '') + 'value="' + data[i].zdbh + '">' + data[i].zdmc + '</option>'
                    }
                    $(this).html(html);
                });
            } else {
                $(selectid).each(function() {
                    $(this).html('<option value="">--请选择--</option>');
                })
            }
        }
    });
}

// 表格合并相同列
function _w_table_rowspan(_w_table_id, _w_table_colnum) {
    _w_table_firsttd = "";
    _w_table_currenttd = "";
    _w_table_SpanNum = 0;
    _w_table_Obj = $(_w_table_id + " tr td:nth-child(" + _w_table_colnum + ")");
    _w_table_Obj.each(function(i) {
        if (i == 0) {
            _w_table_firsttd = $(this);
            _w_table_SpanNum = 1;
        } else {
            _w_table_currenttd = $(this);
            if (_w_table_firsttd.text() == _w_table_currenttd.text() && _w_table_firsttd.prev().text() == _w_table_currenttd.prev().text()) { // 这边注意不是val（）属性，而是text（）属性
                _w_table_SpanNum++;
                _w_table_currenttd.hide(); // remove();
                _w_table_firsttd.attr("rowSpan", _w_table_SpanNum);
            } else {
                _w_table_firsttd = $(this);
                _w_table_SpanNum = 1;
            }
        }
    });
}

// 文件公共下载方法
function downloadFile(id, newtab) {
    if(id){
        if (newtab) {
            window.open(smartec.ctx + "/setting/file/download/" + id + ".do");
        } else {
            window.location.href = smartec.ctx + "/setting/file/download/" + id + ".do";
        }
    }
}

// 文件地址方法
function getFilePath(id) {
    return smartec.ctx + "/setting/file/download/" + id + ".do";
}


// 通用导出excel的方法
function export2Excel(export_url, export_params, headers, filename) {
    export_params.rows = 999999999;// 导出excel设定是不分页，所以按照最大支持不超过10亿数据量导出。

    var title_name_cols = [];
    var title_value_cols = [];
    for (var i = 0; headers && i < headers.length; i++) {
        if (headers[i].name == "rn" || headers[i].label == "操作" || headers[i].hidden == true) {
            continue;
        }
        title_name_cols.push(headers[i].label);
        title_value_cols.push(headers[i].name);
    }
    if (export_url) {
        $.ajax({
            type : 'POST',
            url : export_url,
            datatype : 'json',
            async : false,
            data : export_params,
            success : function(data) {
                var data = {
                    "title_name_cols" : title_name_cols,
                    "title_value_cols" : title_value_cols,
                    "rows" : data.rows
                };
                JSONToExcelConvertor(data, filename ? filename : "未命名");
            }
        });
    }
}

// 导出excel配套方法
function JSONToExcelConvertor(JSONData, FileName) {
    if (JSONData && JSONData.title_name_cols && JSONData.title_value_cols && JSONData.rows && JSONData.rows.length > 0) {
        var excel = '<table>';
        // 设置表头
        var row = "<tr>";
        for (var i = 0; i < JSONData.title_name_cols.length; i++) {
            row += "<td>" + JSONData.title_name_cols[i] + '</td>';
        }
        excel += row + "</tr>";
        // 设置数据

        for (var i = 0; i < JSONData.rows.length; i++) {
            row = "<tr>";
            for (var j = 0; j < JSONData.title_value_cols.length; j++) {
                row += "<td>" + JSONData.rows[i][JSONData.title_value_cols[j]] + '</td>';
            }
            excel += row + "</tr>";
        }

        // 换行
        excel += "</table>";

        var excelFile = "<html xmlns:o='urn:schemas-microsoft-com:office:office' xmlns:x='urn:schemas-microsoft-com:office:excel' xmlns='http://www.w3.org/TR/REC-html40'>";
        excelFile += '<meta http-equiv="content-type" content="application/vnd.ms-excel; charset=UTF-8">';
        excelFile += '<meta http-equiv="content-type" content="application/vnd.ms-excel';
        excelFile += '; charset=UTF-8">';
        excelFile += "<head>";
        excelFile += "<!--[if gte mso 9]>";
        excelFile += "<xml>";
        excelFile += "<x:ExcelWorkbook>";
        excelFile += "<x:ExcelWorksheets>";
        excelFile += "<x:ExcelWorksheet>";
        excelFile += "<x:Name>";
        excelFile += "{worksheet}";
        excelFile += "</x:Name>";
        excelFile += "<x:WorksheetOptions>";
        excelFile += "<x:DisplayGridlines/>";
        excelFile += "</x:WorksheetOptions>";
        excelFile += "</x:ExcelWorksheet>";
        excelFile += "</x:ExcelWorksheets>";
        excelFile += "</x:ExcelWorkbook>";
        excelFile += "</xml>";
        excelFile += "<![endif]-->";
        excelFile += "</head>";
        excelFile += "<body>";
        excelFile += excel;
        excelFile += "</body>";
        excelFile += "</html>";

        var uri = 'data:application/vnd.ms-excel;charset=utf-8,' + encodeURIComponent(excelFile);
        var link = document.createElement("a");
        link.href = uri;
        link.style = "visibility:hidden";
        link.download = FileName + ".xls";
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }
}

//动态加载css脚本
function loadStyleString(_window,cssText) {
    var style = _window.document.createElement("style");
    style.type = "text/css";
    try{
        // firefox、safari、chrome和Opera
        style.appendChild(_window.document.createTextNode(cssText));
    }catch(ex) {
        // IE早期的浏览器 ,需要使用style元素的stylesheet属性的cssText属性
        style.styleSheet.cssText = cssText;
    }
    _window.document.getElementsByTagName("head")[0].appendChild(style);
}

function relogin(){
    location.href=smartec.ctx+"/login.do";
}



function loadBadges() {

    //badge_ajpc_total = badge_ajpc_pcgg_total(badge_ajpc_pcgg_ggsh,badge_ajpc_pcgg_dwbl) +badge_ajpc_ajpc_total(badge_ajpc_ajpc_dwpc)
    //badge_sjpx_total = badge_sjpx_pxgg_total(badge_sjpx_pxgg_ggsh,badge_sjpx_pxgg_dwbl) +badge_sjpx_sjpx_total(badge_sjpx_sjpx_dwpx)
    //badge_xxgk_total = badge_xxgk_xxsh + badge_xxgk_dwck

    var badgeObject = {
        badge_ajpc_pcgg_ggsh:0,
        badge_ajpc_pcgg_dwbl:0,
        badge_ajpc_ajpc_dwpc:0,
        badge_sjpx_pxgg_ggsh:0,
        badge_sjpx_pxgg_dwbl:0,
        badge_sjpx_sjpx_dwpx:0,
        badge_xxgk_xxsh:0,
        badge_xxgk_dwck:0
    };
    for(var badgetype in badgeObject){
        if($("#"+badgetype).length > 0 ){
            //get count(type must be number)
            badgeObject[badgetype] = 1;
        }
    }

    badgeObject["badge_ajpc_pcgg_total"] = badgeObject["badge_ajpc_pcgg_ggsh"] + badgeObject["badge_ajpc_pcgg_dwbl"];
    badgeObject["badge_ajpc_ajpc_total"] = badgeObject["badge_ajpc_ajpc_dwpc"]
    badgeObject["badge_ajpc_total"] = badgeObject["badge_ajpc_pcgg_total"] + badgeObject["badge_ajpc_ajpc_total"];

    badgeObject["badge_sjpx_pxgg_total"] = badgeObject["badge_sjpx_pxgg_ggsh"] + badgeObject["badge_sjpx_pxgg_dwbl"];
    badgeObject["badge_sjpx_sjpx_total"] = badgeObject["badge_sjpx_sjpx_dwpx"]
    badgeObject["badge_sjpx_total"] = badgeObject["badge_sjpx_pxgg_total"] + badgeObject["badge_sjpx_sjpx_total"];

    badgeObject["badge_xxgk_total"] = badgeObject["badge_xxgk_xxsh"] + badgeObject["badge_xxgk_dwck"];

    for(var badgetype in badgeObject){
        if(badgeObject[badgetype]>0){$("#"+badgetype).text(badgeObject[badgetype]);}
    }


}