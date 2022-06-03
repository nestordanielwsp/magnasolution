
//Constructor para obtener y guardar datos de una forma
var FormHandler = function ($http, options, onSuccess, onError) {      
    this.HandlerError = function (detail) {
        var obj = new Object();
        try {
            obj = JSON.parse(detail.Message)
        }
        catch (e) {
            obj.Message = detail.Message;
        }

        //Cuando se termino la sessión el mensaje contiene un -999
        if (obj.Message.indexOf("-999") > -1) {

            obj.Message = obj.Message.replace("-999.-", '');
            Ex.mensajes(obj.Message, 1, Ex.GetResourceValue('title-sin-conexion') == '' ? 'SIN Conexión' : Ex.GetResourceValue('title-sin-conexion'), null, null, function () {
                if (window.parent) window.parent.location = aplicacionURL + 'pages/login.aspx';
            });
        } else {
            //Usamos el prefijo "efdb" error from data base para poder enviar mensajes de error en el idioma de la aplicación.
            if (obj.Message.startsWith('efdb')) {
                if (obj.Message.indexOf('|') > 0) {
                    var keys = obj.Message.split('|');
                    var message = '';
                    if (keys.length > 0) {
                        message = Ex.GetResourceValue(keys[0]);

                        if (message.length == 0) {
                            message = 'No se encontró el recurso ' + ' ' + keys[0] + ':';
                        }
                    }

                    for (var i = 0; i < keys.length; i++) {
                        if (i > 0) {
                            message = message.replaceAll('{' + (i - 1).toString() + '}', keys[i]);
                        }
                    }

                    Ex.mensajes(message);

                }
                else {
                    Ex.mensajes(obj.Message);
                }
            }
            else {
                Ex.mensajes(obj.Message);
            }
        }
    };

};


var validExtension = function (fileName) {
    validExtensions = Ex.GetResourceValue("ExtensionesValidas").split(',');
    extension = (fileName.substring(fileName.lastIndexOf(".") + 1)).toLowerCase();
    for (var i = 0; i < validExtensions.length; i++) {
        if (validExtensions[i] == extension) {
            return true;
        }
    }
    return false;
};

var _rfc_pattern_pm = "^(([A-Z&]{3})([0-9]{2})([0][13578]|[1][02])(([0][1-9]|[12][\\d])|[3][01])([A-Z0-9]{3}))|" +
    "(([A-Z&]{3})([0-9]{2})([0][13456789]|[1][012])(([0][1-9]|[12][\\d])|[3][0])([A-Z0-9]{3}))|" +
    "(([A-Z&]{3})([02468][048]|[13579][26])[0][2]([0][1-9]|[12][\\d])([A-Z0-9]{3}))|" +
    "(([A-Z&]{3})([0-9]{2})[0][2]([0][1-9]|[1][0-9]|[2][0-8])([A-Z0-9]{3}))$";
var _rfc_pattern_pf = "^(([A-Z&]{4})([0-9]{2})([0][13578]|[1][02])(([0][1-9]|[12][\\d])|[3][01])([A-Z0-9]{3}))|" +
    "(([A-Z&]{4})([0-9]{2})([0][13456789]|[1][012])(([0][1-9]|[12][\\d])|[3][0])([A-Z0-9]{3}))|" +
    "(([A-Z&]{4})([02468][048]|[13579][26])[0][2]([0][1-9]|[12][\\d])([A-Z0-9]{3}))|" +
    "(([A-Z&]{4})([0-9]{2})[0][2]([0][1-9]|[1][0-9]|[2][0-8])([A-Z0-9]{3}))$";


var $Ex;
if (!$Ex) {
    $Ex = {};
}

(function () {
    "use strict";
    $Ex.version = "1.1";
    $Ex.Http = null;
    $Ex.Sucess = function () {
        Ex.load(false);
        $("#loading").removeClass("empresa-loader");
    };

    $Ex.Error = function (detail) {
        Ex.load(false);
        this.HandlerError(detail);
    };

    $Ex.HandlerError = function (detail) {
        var obj = new Object();
        try {
            if (detail == null) {
                detail = ''
            }
            else {
                obj = JSON.parse(detail.Message)
            }
        }
        catch (e) {
            obj.Message = detail.Message;
        }

        if (typeof (detail) == 'string') {
            obj.Message = detail;
        }

        //Cuando se termino la sessión el mensaje contiene un -999
        if (obj.Message.indexOf("-999") > -1) {

            obj.Message = obj.Message.replace("-999.-", '');
            Ex.mensajes(obj.Message, 1, Ex.GetResourceValue('title-sin-conexion') == '' ? 'SIN Conexión' : Ex.GetResourceValue('title-sin-conexion'), null, null, function () {
                if (window.parent) window.parent.location = aplicacionURL + 'pages/login.aspx';
            });
        } else {
            //Usamos el prefijo "efdb" error from data base para poder enviar mensajes de error en el idioma de la aplicación.
            if (obj.Message.startsWith('efdb')) {
                if (obj.Message.indexOf('|') > 0) {
                    var keys = obj.Message.split('|');
                    var message = '';
                    if (keys.length > 0) {
                        message = Ex.GetResourceValue(keys[0]);

                        if (message.length == 0) {
                            message = 'No se encontró el recurso ' + ' ' + keys[0] + ':';
                        }
                    }

                    for (var i = 0; i < keys.length; i++) {
                        if (i > 0) {
                            message = message.replaceAll('{' + (i - 1).toString() + '}', keys[i]);
                        }
                    }

                    Ex.mensajes(message, 5);

                }
                else {
                    Ex.mensajes(obj.Message, 5);
                }
            }
            else {
                Ex.mensajes(obj.Message + ". " + detail.StackTrace, 4);
            }
        }
    };

    $Ex.Execute = function (serverMethod, data, onSuccess, form, load, additionalRulesfn, isload, page) {
        try {
            if (typeof (load) == 'undefined') {
                load = true;
            }
            if (load) {
                Ex.load(true);
                $("#loading").addClass("empresa-loader");
            }
            var lastData = $.extend({}, data);

            if (typeof (form) != 'undefined') {
                if (form.$invalid) {
                    var msgRequiredField = '';
                    msgRequiredField = Ex.GetGlobalResourceValue('msgRequiredFields');
                    if (typeof (form.msgInvalidForm) != 'undefined') {
                        msgRequiredField = form.msgInvalidForm;
                    }

                    var isInvalidMaxValue = false;
                    var isInvalidmaxlength = false;
                    var isInvalidEmail = false;
                    var isInvalidRFC = false;
                    var isInvalidUrl = false;
                    for (var type in form.$error) {
                        if (type == 'max') {
                            isInvalidMaxValue = true;
                        }

                        if (type == 'maxlength') {
                            isInvalidmaxlength = true;
                        }

                        if (type == 'email' || type == "validEmail") {
                            isInvalidEmail = true;
                        }

                        if (type == "validRfc") {
                            isInvalidRFC = true;
                        }

                        if (type == 'url')
                            isInvalidUrl = true;

                    }

                    if (isInvalidMaxValue) {
                        msgRequiredField = Ex.GetGlobalResourceValue("msgExceedMaxValue");
                    }

                    if (isInvalidmaxlength) {
                        msgRequiredField = Ex.GetGlobalResourceValue("msgExcedeLongitudMaxima");
                    }

                    if (isInvalidEmail) {
                        msgRequiredField = Ex.GetGlobalResourceValue("msgInvalidEmail");
                    }

                    if (isInvalidRFC) {
                        msgRequiredField = Ex.GetGlobalResourceValue("msgInvalidRFC");
                    }

                    if (isInvalidUrl) {
                        msgRequiredField = Ex.GetGlobalResourceValue("msgInvalidUrl");
                    }

                    Ex.mensajes(msgRequiredField, 5);
                    Ex.load(false);
                    $("#loading").removeClass("empresa-loader");
                    onSuccess(null, true);
                    return;
                }
            }

            if (typeof (additionalRulesfn) == 'function') {
                if (!additionalRulesfn()) {
                    Ex.load(false);
                    $("#loading").removeClass("empresa-loader");
                    return;
                }
            }

            //Verifica si existen propiedades que son de tipo arreglo y las serializa.... 
            for (var element in lastData) {
                var type = typeof (lastData[element]);
                if (type == 'object') {
                    if (Array.isArray(lastData[element])) {
                        lastData[element] = JSON.stringify(data[element]);
                    }
                }
            }


            $Ex.Http.post(location.pathname + '/' + serverMethod, { datos: lastData })
                .success(function (response) {
                    if (typeof (onSuccess) === 'function') {
                        onSuccess(response);
                        if (isload == undefined || isload) {
                            Ex.load(false);
                            $("#loading").removeClass("empresa-loader");
                        }
                    }
                    else {
                        $Ex.Sucess();
                    }
                })
                .error(function (result, result2, result3) {
                    if (page != undefined) {
                        page.isValid = false;
                    }
                    $Ex.Error(result);
                    Ex.load(false);
                    $("#loading").removeClass("empresa-loader");
                });
        }
        catch (ex) {
            Ex.mensajes(ex.message, 4);
            Ex.load(false);
            $("#loading").removeClass("empresa-loader");
        }
    }

    $Ex.IsValidateRequiredFieldForm = function (form) {
        if (typeof (form) != 'undefined') {
            if (form.$invalid) {
                var msgRequiredField = '';
                msgRequiredField = Ex.GetGlobalResourceValue('msgRequiredFields');
                if (typeof (form.msgInvalidForm) != 'undefined') {
                    msgRequiredField = form.msgInvalidForm;
                }
                var isInvalidMinValue = false;
                var isInvalidMaxValue = false;
                var isInvalidmaxlength = false;
                var isInvalidEmail = false;
                var isInvalidRFC = false;

                for (var type in form.$error) {

                    if (type == 'min') {
                        isInvalidMinValue = true;
                    }

                    if (type == 'max') {
                        isInvalidMaxValue = true;
                    }

                    if (type == 'maxlength') {
                        isInvalidmaxlength = true;
                    }

                    if (type == 'email') {
                        isInvalidEmail = true;
                    }

                    if (type == 'validEmail')
                        isInvalidEmail = true;

                    if (type == 'validRfc')
                        isInvalidRFC = true;

                }

                if (isInvalidMinValue) {
                    msgRequiredField = Ex.GetGlobalResourceValue("msgExceedMinValue");
                }

                if (isInvalidMaxValue) {
                    msgRequiredField = Ex.GetGlobalResourceValue("msgExceedMaxValue");
                }

                if (isInvalidmaxlength) {
                    msgRequiredField = Ex.GetGlobalResourceValue("msgExcedeLongitudMaxima");
                }

                if (isInvalidEmail) {
                    msgRequiredField = Ex.GetGlobalResourceValue("msgInvalidEmail");
                }

                if (isInvalidRFC) {
                    msgRequiredField = Ex.GetGlobalResourceValue("msgInvalidRFC");
                }

                Ex.mensajes(msgRequiredField, 5);
                Ex.load(false);
                return false;
            }
        }

        return true;
    }

    $Ex.GetTranslateMultiSelectSettings = function () {
        return {
            buttonDefaultText: Ex.GetGlobalResourceValue("labelDefaulMultiselect"),
            checkAll: Ex.GetGlobalResourceValue("labelCheckAllMultiselect"),
            uncheckAll: Ex.GetGlobalResourceValue("labelUnCheckAllMultiselect"),
            selectionCount: Ex.GetGlobalResourceValue("labelSelectionCount"),
            searchPlaceholder: Ex.GetGlobalResourceValue("labelsearchPlaceholder"),
            dynamicButtonTextSuffix: Ex.GetGlobalResourceValue("labeldynamicButtonTextSuffix"),
            buttonClasses: 'btn btn-multiselect'
        }
    }

    $Ex.FormatDate = function (date) {

        var splitDate = ''
        var returnDate = '';

        if (date == null || typeof (date) == 'undefined')
            return '';

        if (date.length > 0) {
            splitDate = date.split("/");
            returnDate = new Date(splitDate[2], splitDate[1] - 1, splitDate[0]);
            var format = Ex.GetGlobalResourceValue("calendarFormat").replace("mm", "MM");

            returnDate = returnDate.format(format);
        }

        return returnDate;
    }

    $Ex.FormatMoney = function (number, decimals) {
        if (number == null || typeof (number) == 'undefined')
            return '';

        return number.toFixed(decimals).replace(/./g, function (c, i, a) {
            return i > 0 && c !== "." && (a.length - i) % 3 === 0 ? "," + c : c;
        });

    }

    $Ex.OrderNumber = function (string) {
        var formattedOrderNumber = string;

        try {
            var len = formattedOrderNumber.length;
            if (len > 4) {
                formattedOrderNumber = formattedOrderNumber.substring(0, formattedOrderNumber.length - 4) + '-' + formattedOrderNumber.substring(formattedOrderNumber.length - 4, formattedOrderNumber.length);
            }
        }
        catch (e) {
            return string;
        }

        return formattedOrderNumber;
    }

    $Ex.BOLNumber = function (string) {
        var formattedBOLNumber = string;

        try {
            var len = formattedBOLNumber.length;
            if (len > 4) {
                formattedBOLNumber = string.substring(0, string.length - 3) + '-' + string.substring(string.length - 3, string.length);
            }
        }
        catch (e) {
            return string;
        }

        return formattedBOLNumber;
    }


    $Ex.LoadNumber = function (string) {
        var formattedOrderNumber = string;

        try {
            var len = formattedOrderNumber.length;
            if (len > 7) {
                formattedOrderNumber = string.substring(0, string.length - 7) + '-' + string.substring(string.length - 7, string.length - 3) + '-' + string.substring(string.length - 3, string.length);
            }
        }
        catch (e) {
            return string;
        }

        return formattedOrderNumber;
    }

    $Ex.GetArrayPropertyByValue = function (items, colID, valueID, colName) {

        if (typeof (items) == 'undefined')
            return '';

        for (var i = 0; i < items.length; i++) {
            if (items[i][colID] == valueID) {
                return items[i][colName];
            }
        }
    }

    $Ex.DateDiff = function (toDate, fromDate) {
        if (toDate && fromDate) {
            var magicNumber = (1000 * 60 * 60 * 24);
            var dayDiff = Math.floor((toDate - fromDate) / magicNumber);
            if (angular.isNumber(dayDiff)) {
                return dayDiff + 1;
            }
        }
    }

    $Ex.ValidaRFC = function (rfc) {
        rfc = rfc.toUpperCase();
        if (rfc.match(_rfc_pattern_pm) || rfc.match(_rfc_pattern_pf)) {
            return true;
        } else {
            return false;
        }
    };

}());
