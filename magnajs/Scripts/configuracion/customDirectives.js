
window.config = { IdVariable: "Id" }

function refreshBodyHeight() {
    $("html").removeAttr("style");
    $("html").height($(document).height() + 40);
}
function toDate(dateStr, delimiter) {
    var parts = dateStr.split(delimiter);
    return new Date(parts[2], parts[1] - 1, parts[0], "23", "59", "59");
}

function focusID(id) {
    $("#" + id).first().focus();
}
function focusName(type, obj, element) {
    if (element == 'last')
        $(type + "[name='" + obj + "']").last().focus();
    else if (element == 'first')
        $(type + "[name='" + obj + "']").first().focus();
}
function sleep(milliseconds) {
    var start = new Date().getTime();
    for (var i = 0; i < 1e7; i++) {
        if ((new Date().getTime() - start) > milliseconds) {
            break;
        }
    }
}


function sortJsonArray(array, key) {
    return array.sort(function (a, b) {
        var x = a[key]; var y = b[key];
        return ((x < y) ? -1 : ((x > y) ? 1 : 0));
    });
}

/**
 * Number.prototype.format(n, x)
 * 
 * @param integer n: length of decimal
 * @param integer x: length of sections
 */
function getDecimalFormat(num, n, x) {
    var re = '\\d(?=(\\d{' + (x || 3) + '})+' + (n > 0 ? '\\.' : '$') + ')';
    return num.toFixed(Math.max(0, ~~n)).replace(new RegExp(re, 'g'), '$&,');
}

function getDecimal(num) {

    if (num !== undefined) {
        if (num.toString().length > 0) {
            if (!isNaN(num.toString())) {
                return parseInt(num);
            }
            else
                return 0;
        }
    }
    return 0;
}
function getInt(num) {

    if (num !== undefined) {
        if (num.toString().length > 0) {
            if (!isNaN(num.toString())) {
                return parseInt(num);
            }
            else
                return 0;
        }
    }
    return 0;
}

function getRandom(num) {
    if (num == undefined)
        return Math.floor(Math.random() * 999) + 1;
    else
        return Math.floor(Math.random() * num) + 1;
}
function getDateTimeYMD() {
    var d = new Date();
    var n = d.getFullYear().toString() + pad(d.getMonth() + 1, 2) + pad(d.getDate(), 2) + pad(d.getHours(), 2)
        + pad(d.getMinutes(), 2) + pad(d.getSeconds(), 2) + pad(d.getMilliseconds(), 4);
    return n;
}
function getDateNowDMY() {
    var d = new Date();
    var n = pad(d.getDate(), 2) + '/' + pad(d.getMonth() + 1, 2) + '/' + d.getFullYear().toString();
    return n;
}

function pad(str, max) {
    str = str.toString();
    return str.length < max ? pad("0" + str, max) : str;
}


function copyJsonObj(itemFrom, itemTo) {
    for (var key in itemFrom) {
        if (itemFrom.hasOwnProperty(key) && key != "itemAux") {

            itemTo[key] = itemFrom[key];
        }
    }
}

var getObjectByValue = function (array, key, value) {
    return array.filter(function (object) {
        return object[key] === value;
    });
};

(function () {
    var app = angular.module("customDirectives", []);

    app.run(function ($rootScope) {
        $rootScope.copyJsonObj = function (itemFrom, itemTo) {
            for (var key in itemFrom) {
                if (itemFrom.hasOwnProperty(key)) {

                    itemTo[key] = itemFrom[key];
                }
            }
        };
    });

    var appSettings = {};

    appSettings.RangeCalendarMaximumDays = 90;


    app.directive('file', function () {
        return {
            scope: {
                file: '='
            },
            link: function (scope, el, attrs) {
                el.bind('change', function (event) {
                    //var formData = new FormData();
                    //formData.append("Files", event.target.files[0]);

                    var files = event.target.files;

                    var data = new FormData(this);
                    for (var i = 0; i < files.length; i++) {

                        if (validExtension(files[i].name)) {

                            if (files[i].size / 1000000 <= Ex.GetResourceValue("TamanioInvalido")) {
                                data.append(files[i].name, files[i]);
                            }
                            else {
                                event.target.value = "";
                                Ex.mensajes(Ex.GetResourceValue("msgTamanioInvalido"));
                                return;
                            }
                        }
                        else {
                            event.target.value = "";
                            Ex.mensajes(Ex.GetResourceValue("msgExtensionesValidas"));
                            return;
                        }
                    }

                    data.append('Pagina', this.alt);

                    //var options = {};
                    //options.url = "../Codes/UploadFile.ashx";
                    //options.type = "POST";
                    //options.data = data;
                    ////options.contentType = false;
                    //options.processData = false;
                    //options.contentType = 'multipart/form-data';
                    //options.success = function (result) {
                    //    var file = files[0];
                    //    scope.file = file ? file.name : undefined;
                    //    scope.$apply();
                    //};
                    //options.error = function (err) {
                    //    Ex.mensajes(err.status + " - " + err.statusText);
                    //};

                    //$.ajax(options);

                    //evt.preventDefault()

                    var request = new XMLHttpRequest();
                    request.open("POST", "../Codes/UploadFile.ashx");
                    request.send(data);

                    var files = event.target.files;
                    var file = files[0];
                    scope.file = file ? file.name : undefined;
                    scope.$apply();
                });
            }
        };
    });
    app.directive("selectpicker2",
        [
            "$timeout",
            function ($timeout) {
                return {
                    restrict: "A",
                    require: ["ngModel", "collectionName"],
                    compile: function (tElement, tAttrs, transclude) {
                        //console.log("init bootstrap-select");
                        tElement.selectpicker();

                        if (angular.isUndefined(tAttrs.ngModel)) {
                            throw new Error("Please add ng-model attribute!");
                        } else if (angular.isUndefined(tAttrs.collectionName)) {
                            throw new Error("Please add data-collection-name attribute!");
                        }

                        return function (scope, element, attrs, ngModel) {
                            if (angular.isUndefined(ngModel)) {
                                return;
                            }

                            scope.$watch(attrs.ngModel, function (newVal, oldVal) {
                                if (newVal !== oldVal) {
                                    $timeout(function () {
                                        console.log("value selected");
                                        element.selectpicker("val", element.val());
                                    });
                                }
                            });

                            scope.$watch(attrs.collectionName, function (newVal, oldVal) {
                                $timeout(function () {
                                    console.log("select collection updated");
                                    element.selectpicker("refresh");
                                });
                            });

                            ngModel.$render = function () {
                                element.selectpicker("val", ngModel.$viewValue || "");
                                element.selectpicker('refresh');
                            };

                            ngModel.$viewValue = element.val();
                        };
                    }
                }
            }
        ]
    );
    app.directive('selectpicker', ['$parse', function ($parse) {
        return {
            restrict: 'A',
            require: 'ngModel',
            priority: 10,
            compile: function (tElement, tAttrs, transclude) {
                //tElement.selectpicker($parse(tAttrs.selectpicker)());
                //tElement.selectpicker('refresh');
                return function (scope, element, attrs, ngModel) {
                    if (!ngModel) return;

                    element.bind("change", function (event) {
                        if (ngModel.$viewValue == -1)
                            element.selectpicker('hide');
                    });

                    scope.$watch(attrs.ngModel, function (newVal, oldVal) {
                        scope.$evalAsync(function () {
                            //element.val(newVal);
                            //if (!attrs.ngOptions || /track by/.test(attrs.ngOptions)) element.val(newVal);
                            //element.selectpicker('val', newVal);
                            // element.selectpicker("val", "number:" + ngModel.$viewValue || "");
                        });
                    });

                    ngModel.$render = function () {
                        scope.$evalAsync(function () {
                            //  element.selectpicker({ createItem: true });
                            element.selectpicker("refresh");
                        });
                    }
                };
            }

        };
    }]);

    app.directive('validEmail', function () {
        return {
            require: 'ngModel',
            link: function (scope, element, attrs, ctrl) {
                ctrl.$parsers.unshift(function (viewValue) {

                    var emails = viewValue.split(',');
                    // define single email validator here
                    // var re = /\S+@\S+\.\S+/;
                    var re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;

                    // angular.foreach(emails, function() {
                    var validityArr = emails.map(function (str) {
                        return re.test(str.trim());
                    }); // sample return is [true, true, true, false, false, false]
                    console.log(emails, validityArr);
                    var atLeastOneInvalid = false;
                    angular.forEach(validityArr, function (value) {
                        if (value === false)
                            atLeastOneInvalid = true;
                    });
                    if (!atLeastOneInvalid) {
                        // ^ all I need is to call the angular email checker here, I think.
                        ctrl.$setValidity('validEmail', true);
                        return viewValue;
                    } else {
                        ctrl.$setValidity('validEmail', false);
                        return undefined;
                    }
                    // })
                });
            }
        };
    });
    app.directive('validRfc', function () {
        return {
            require: 'ngModel',
            link: function (scope, element, attrs, ctrl) {
                ctrl.$parsers.unshift(function (viewValue) {

                    var rfc = viewValue.toString().toUpperCase();

                    var aceptarGenerico = true;

                    const re = /^([A-ZÑ&]{3,4}) ?(?:- ?)?(\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01])) ?(?:- ?)?([A-Z\d]{2})([A\d])$/;
                    var validado = rfc.match(re);

                    if (!validado)  //Coincide con el formato general del regex?
                    {
                        ctrl.$setValidity('validRfc', false);
                        ctrl.$setViewValue(rfc);
                        ctrl.$render();
                        return rfc;
                    }

                    //Separar el dígito verificador del resto del RFC
                    const digitoVerificador = validado.pop(),
                        rfcSinDigito = validado.slice(1).join(''),
                        len = rfcSinDigito.length,

                        //Obtener el digito esperado
                        diccionario = "0123456789ABCDEFGHIJKLMN&OPQRSTUVWXYZ Ñ",
                        indice = len + 1;
                    var suma,
                        digitoEsperado;

                    if (len == 12) suma = 0
                    else suma = 481; //Ajuste para persona moral

                    for (var i = 0; i < len; i++)
                        suma += diccionario.indexOf(rfcSinDigito.charAt(i)) * (indice - i);
                    digitoEsperado = 11 - suma % 11;
                    if (digitoEsperado == 11) digitoEsperado = 0;
                    else if (digitoEsperado == 10) digitoEsperado = "A";

                    //El dígito verificador coincide con el esperado?
                    // o es un RFC Genérico (ventas a público general)?
                    if ((digitoVerificador != digitoEsperado)
                        && (!aceptarGenerico || rfcSinDigito + digitoVerificador != "XAXX010101000")) {
                        ctrl.$setValidity('validRfc', false);
                        ctrl.$setViewValue(rfc);
                        ctrl.$render();
                        return rfc;
                    }
                    else if (!aceptarGenerico && rfcSinDigito + digitoVerificador == "XEXX010101000") {
                        ctrl.$setValidity('validRfc', true);
                        ctrl.$setViewValue(rfc);
                        ctrl.$render();
                        return rfc;
                    }

                    ctrl.$setValidity('validRfc', true);
                    ctrl.$setViewValue(rfc);
                    ctrl.$render();
                    return rfc;
                });
            }
        };
    });

    app.directive('appFilter', function () {
        var directive = {};
        directive.restrict = "E";
        directive.template = "<div ng-transclude ></div>";
        directive.transclude = true;
        directive.scope = {
            model: '='
        };
        directive.link = function (scope, elem, attrs) {

            if (scope.model == null) {
                scope.model = {};
            }

            scope.model.getFilters = function () {
                var childs = elem.find("[ng-model]");
                var arrFilter = [];
                for (var i = 0; i < childs.length; i++) {
                    var child = $(childs[i]);

                    var modelParts = child.attr("ng-model").split(".");
                    var model = modelParts[modelParts.length - 1];

                    var fieldName = child.attr("fieldname");
                    if (fieldName == null) {
                        fieldName = model;
                    }

                    var filterItem = {};

                    filterItem.Value = scope.model[model];
                    filterItem.FieldName = fieldName;
                    filterItem.Comparison = child.attr("comparison");
                    if (filterItem.Comparison == null) {
                        filterItem.Comparison = "Equals";
                    }
                    arrFilter.push(filterItem);
                }

                console.log(arrFilter);

                return arrFilter;

            }

        };

        return directive;
    });

    app.directive('uiModal', function () {
        var directive = {};

        directive.restrict = "E";
        directive.template = '<div ng-transclude class="modal fade" role="dialog" style="display:none; height: auto;">';
        directive.transclude = true;
        directive.scope = {
            modal: '=',
            size: '@',
            id: '@'
        };

        directive.link = function (scope, element, attrs) {

            var div = $("[role=dialog]:first", element);

            for (var attr in attrs.$attr) {
                if (attrs.hasOwnProperty(attr)) {
                    div.attr(attrs.$attr[attr], attrs[attr]);
                }
            }

            div.addClass(scope.size);

            if (typeof (scope.id) != 'undefined') {
                if (scope.id.length > 0) {
                    div.id = scope.id;
                }
            }

            if (scope.modal == null) {
                scope.modal = {};
            }

            scope.modal.open = function () {
                div.modal('show');
            };

            scope.modal.close = function () {
                div.modal('hide');
            };

            div.on('shown.bs.modal', function () {
                $(".modal-open .modal").css("overflow-y", "hidden");
            });
        };
        return directive;
    });

    app.directive('datetimepicker', function () {
        var directive = {};

        directive.restrict = "E";
        directive.require = 'ngModel';
        directive.template = '<input type="text" class="form-control" ng-model="selectedDate" ng-change="dateChanged" ng-required="isRequired" ng-disabled="isDisabled"/>';
        directive.scope = {
            datetimepickerOptions: '=',
            isRequired: '@',
            modelValue: '=ngModel',
            isDisabled: '@'
        };

        directive.link = function (scope, element, attr, modelController) {
            var $input = $(element).find("input");
            scope.datetimepickerOptions = scope.datetimepickerOptions != undefined ? scope.datetimepickerOptions : {};


            var defaults = {
                format: "HH:mm",
                widgetParent: "body"
            };

            scope.datetimepickerOptions = _.defaults(scope.datetimepickerOptions, defaults);

            $input.datetimepicker(scope.datetimepickerOptions);

            $input.on('dp.change', function (event) {
                $input.data("DateTimePicker").date(this.value);
                $input.data("DateTimePicker").viewDate(this.value);
                scope.selectedDate = this.value;
                modelController.$setViewValue(this.value);
            });

            scope.isRequired = attr.hasOwnProperty("isRequired");

            scope.$watch('isRequired', function (newVal) {
                if (typeof newVal === 'string') {
                    scope.isRequired = newVal === "true";
                }
            });

            scope.isDisabled = attr.$attr.hasOwnProperty("isDisabled");

            scope.$watch('isDisabled', function (newVal) {
                if (typeof newVal === 'string') {
                    scope.isDisabled = newVal === "true";
                }
            });

            modelController.$formatters.push(function (modelValue) {
                var value = modelValue === undefined ? "" : modelValue;
                $input.data("DateTimePicker").date(value);
                scope.selectedDate = value;

            });
        };
        return directive;
    });

    app.directive('datepicker', ["$timeout", function ($timeout) {
        var directive = {};

        directive.restrict = "E";
        directive.require = 'ngModel';
        directive.template = function (element, attr) {
            var inputClass = attr.hasOwnProperty("inputClass") ? attr.inputClass : "input-sm form-control";

            var template = '<div class="calendar">' +
                '<input type="text" class="no-disabled ' + inputClass + '" ng-model="selectedDate" ng-change="dateChanged" ' +
                'ng-required="isRequired" ng-hide="isHide"' +
                'ng-class="{\'no-disabled\': noDisabled}"/>' +
                '</div>';

            return template;
        };
        directive.scope = {
            datepickerOptions: '=?',
            isRequired: '@',
            modelValue: '=ngModel',
            minDate: '=',
            isDisabled: '@',
            onChanged: '&?'
        };

        directive.link = function (scope, element, attr, modelController) {
            var $input = $(element).find("input");
            scope.noDisabled = attr.hasOwnProperty("noDisabled");

            scope.datepickerOptions = scope.datepickerOptions != undefined ? scope.datepickerOptions : {};

            var defaults = {
                orientation: "auto",
                format: Ex.GetGlobalResourceValue("calendarFormat"),
                language: Ex.GetGlobalResourceValue("calendarLanguage"),
                autoclose: true
            };

            if (scope.minDate != null) {
                defaults.startDate = scope.minDate
            }

            scope.datepickerOptions = _.defaults(scope.datepickerOptions, defaults);

            if (typeof (scope.datepickerOptions.endDate) != 'undefined') {
                if (scope.datepickerOptions.endDate.length > 0) {
                    var splitDate = scope.datepickerOptions.endDate.split("/");
                    if (splitDate.length > 1) {
                        scope.datepickerOptions.endDate = new Date(splitDate[2], splitDate[1] - 1, splitDate[0]);
                    }
                }
            }

            if (typeof (scope.datepickerOptions.startDate) != 'undefined') {
                if (scope.datepickerOptions.startDate.length > 0) {
                    var splitDate = scope.datepickerOptions.startDate.split("/");
                    if (splitDate.length > 1) {
                        scope.datepickerOptions.startDate = new Date(splitDate[2], splitDate[1] - 1, splitDate[0]);
                    }
                }
            }

            $(element).datepicker(scope.datepickerOptions);

            // scope.isRequired = attr.hasOwnProperty("isRequired");

            scope.isRequired = attr.hasOwnProperty("isRequired") ? attr.isrequired : false;

            scope.$watch('isRequired', function (newVal) {
                if (typeof newVal === 'string') {
                    scope.isRequired = newVal === "true";
                }
            });

            scope.isDisabled = attr.$attr.hasOwnProperty("isDisabled");

            scope.$watch('isDisabled', function (newVal) {
                if (typeof newVal === 'string') {
                    scope.isDisabled = newVal === "true";
                }
            });

            //Verificamos si no ha cambiado nuestra fecha minima...
            scope.$watch('minDate', function (newVal) {
                if (typeof newVal === 'string') {
                    var selectedDate = $(element).datepicker("getDate");
                    var strDate = moment(newVal, "DD/MM/YYYY");


                    if (selectedDate != null) {
                        if (strDate._d > selectedDate) {
                            strDate = moment(strDate).format("DD/MM/YYYY");
                            scope.selectedDate = strDate;
                            modelController.$setViewValue(strDate);
                            return;
                        }
                    }

                    if (newVal.length > 0) {
                        var splitDate = newVal.split("/");

                        if (splitDate.length > 1) {
                            $(element).data('datepicker').setStartDate(new Date(splitDate[2], splitDate[1] - 1, splitDate[0]));
                        }
                    }
                }
            });

            scope.isHide = attr.$attr.hasOwnProperty("isHide");

            $input.on("change", function () {

                var selectedDate = $(element).datepicker("getDate");
                var strDate = moment(selectedDate, "DD/MM/YYYY");

                if (this.value == '') {
                    strDate = '';
                }

                if (strDate != null) {
                    strDate = moment(strDate).format("DD/MM/YYYY");
                }
                else {
                    $(element).datepicker("setDate", '');
                    scope.selectedDate = "";
                    modelController.$setViewValue("");
                    return
                }

                if (strDate.indexOf("/") != -1) {
                    scope.selectedDate = strDate;
                    modelController.$setViewValue(strDate);
                    $(element).datepicker("setDate", selectedDate);
                } else {
                    $(element).datepicker("setDate", '');
                    scope.selectedDate = "";
                    modelController.$setViewValue("");
                }

                if (scope.hasOwnProperty("onChanged") && strDate != null)
                    scope.onChanged({ date: selectedDate });
            });

            modelController.$formatters.push(function (modelValue) {
                var value = modelValue === undefined ? "" : modelValue;

                var valueAsDate = '';

                if (value != null) {
                    if (value.length > 0) {
                        var splitDate = value.split("/");
                        valueAsDate = new Date(splitDate[2], splitDate[1] - 1, splitDate[0]);
                    }
                }

                scope.selectedDate = value;

                $timeout(function () {
                    var isDisabled = attr.disabled;

                    $input.prop('disabled', isDisabled);
                    $(element).datepicker("setDate", valueAsDate);
                }, 0);

                return modelValue;
            });
        };
        return directive;
    }]);

    app.directive('datepickerRange', ["$timeout", function ($timeout) {
        var directive = {};

        directive.restrict = "E";
        directive.require = 'ngModel';
        directive.template = function (element, attr) {
            var inputClass = attr.hasOwnProperty("inputClass") ? attr.inputClass : "input-sm form-control";

            var template = '<div ng-model="dates" class="input-daterange input-group calendar" id="datepicker"> ' +
                '<input id="startDate" ng-model="StartDate" type="text" class="no-disabled ' + inputClass + '" name="start" ng-required="isRequired"/>' +
                '<span class="input-group-addon">{{labelSeparator}}</span>' +
                '<input id="endDate" ng-model="EndDate" type="text" class="no-disabled ' + inputClass + '" name="end" ng-required="isRequired"/>' +
                '</div>';

            return template;
        }

        directive.scope = {
            option: '=?',
            labelSeparator: '@',
            modelValue: '=ngModel',
            maximumDays: '@',
            onChanged: '&?',
            minDate: '=?'
        };

        directive.link = function (scope, element, attr, modelController) {
            var $inputStart = $(element).find("[name='start']");
            var $inputEnd = $(element).find("[name='end']");
            var openEndDate = true;

            var endEnableClass = attr.hasOwnProperty("endEnable") && attr.endEnable === "true";

            if (endEnableClass)
                $inputEnd.addClass("no-disabled");

            scope.dates = {};
            scope.isRequired = attr.$attr.hasOwnProperty("isRequired");
            scope.labelSeparator = scope.labelSeparator != undefined ? scope.labelSeparator :
                Ex.GetGlobalResourceValue("lblA");
            scope.option = scope.option != undefined ? scope.option : {};
            scope.maximumDays = scope.maximumDays != undefined ? scope.maximumDays : appSettings.RangeCalendarMaximumDays;


            var defaults = {
                orientation: "bottom auto",
                format: Ex.GetGlobalResourceValue("calendarFormat"),
                language: Ex.GetGlobalResourceValue("calendarLanguage"),
                autoclose: true
            };


            scope.option = _.defaults(scope.option, defaults);

            $(".input-daterange").datepicker(scope.option);

            var onKeyup = function (event, element) {
                var number = parseInt(element.value);
                if (isNaN(number)) {
                    element.value.value = "";
                }
                return element.value.replace(/[^0-9//]/g, '');
            };

            $("#startDate, #endDate").on("keyup keydown", function (event) {
                switch (event.type) {
                    case "keyup":
                        this.value = onKeyup(event, this);
                        break;
                    case "keydown":
                        if (event.keyCode !== 8 && (this.value.length === 2 || this.value.length === 5)) {
                            this.value += "/";
                        }
                        break;
                    case "click":
                        $(this).select();
                        break;
                    default:
                }

            });

            $inputStart.on("change", function (e) {
                if (this.value === "") {
                    $inputEnd.datepicker("setDate", "");
                }
            });

            $inputStart.datepicker().on("changeDate", function (e) {
                var startDate;
                var endDate;

                scope.dates.StartDate = this.value;

                if (this.value.length >= 10) {
                    startDate = $inputStart.datepicker("getDate");
                    endDate = $inputEnd.datepicker("getDate");

                    if (!endDate) {
                        $inputEnd.datepicker("setDate", $inputStart.val());
                        endDate = $inputEnd.datepicker("getDate");
                    }

                    var isSameDate = startDate.getFullYear() === endDate.getFullYear() &&
                        startDate.getMonth() === endDate.getMonth() && startDate.getDate() === endDate.getDate();

                    if (isSameDate && openEndDate) {
                        $inputEnd.datepicker("show");
                    } else {
                        openEndDate = true;
                    }

                    $inputEnd.datepicker("setStartDate", startDate);
                } else {
                    $inputEnd.datepicker("setStartDate", "");
                    scope.dates.StartDate = "";
                }

                var value = scope.dates.StartDate !== "" ? scope.dates : null;
                modelController.$setViewValue(value);

                if (scope.hasOwnProperty("onChanged") && value != null) {
                    startDate = $inputStart.datepicker("getDate");
                    endDate = $inputEnd.datepicker("getDate");

                    scope.onChanged({ startDate: startDate, endDate: endDate });
                }
            });

            $inputEnd.on("blur", function () {
                if (this.value === "") {
                    var startDate = $inputStart.val();
                    $inputEnd.datepicker("setDate", startDate);
                }
            });

            $inputEnd.datepicker().on("changeDate", function (e) {
                scope.dates.EndDate = this.value;

                var value = scope.dates.StartDate !== "" ? scope.dates : null;
                modelController.$setViewValue(value);

                if (scope.hasOwnProperty("onChanged") && value != null) {
                    var startDate = $inputStart.datepicker("getDate");
                    var endDate = $inputEnd.datepicker("getDate");

                    scope.onChanged({ startDate: startDate, endDate: endDate });
                }
            });


            modelController.$formatters.push(function (modelValue) {
                if (modelValue && modelValue.hasOwnProperty("StartDate")) {
                    scope.dates.StartDate = modelValue.StartDate;
                    scope.dates.EndDate = modelValue.EndDate;


                    var startDateAsDate = '';
                    var endDateAsDate = '';
                    var splitDate;

                    if (scope.dates.StartDate.length > 0) {
                        splitDate = scope.dates.StartDate.split("/");
                        startDateAsDate = new Date(splitDate[2], splitDate[1] - 1, splitDate[0]);
                    }

                    if (scope.dates.EndDate.length > 0) {
                        splitDate = scope.dates.EndDate.split("/");
                        endDateAsDate = new Date(splitDate[2], splitDate[1] - 1, splitDate[0]);
                    }

                    $timeout(function () {
                        var isDisabled = attr.disabled;

                        $inputStart.prop('disabled', isDisabled);
                        $inputEnd.prop('disabled', isDisabled);

                        openEndDate = false;
                        $inputStart.datepicker("setDate", startDateAsDate);
                        $inputEnd.datepicker("setDate", endDateAsDate);

                    }, 0);
                } else {
                    $inputStart.prop('disabled', false);
                    $inputEnd.prop('disabled', false);

                    $inputStart.datepicker("clearDates");
                    $inputEnd.datepicker("clearDates");
                }

                return modelValue;
            });

            //Verificamos si no ha cambiado nuestra fecha minima...
            scope.$watch('minDate', function (newVal) {
                if (newVal != null && newVal.StartDate.length === 10 && newVal.EndDate.length === 10) {
                    var splitStartDate = newVal.StartDate.split("/");
                    var splitEndDate = newVal.EndDate.split("/");
                    $inputStart.data('datepicker').setStartDate(new Date(splitStartDate[2], splitStartDate[1] - 1, splitStartDate[0]));
                    $inputStart.data('datepicker').setEndDate(new Date(splitEndDate[2], splitEndDate[1] - 1, splitEndDate[0]));
                    $inputEnd.data('datepicker').setEndDate(new Date(splitEndDate[2], splitEndDate[1] - 1, splitEndDate[0]));
                }
            }, true);

            //Deshabilita el calendario
            scope.$watch('option', function (newVal) {
                if (newVal != null && newVal.hasOwnProperty("startDisabled")) {
                    if (newVal.startDisabled) {
                        $inputStart.css("pointer-events", "none");
                    } else {
                        $inputStart.removeAttr("style");
                    }
                }
            }, true);
        };
        return directive;
    }]);

    app.directive('pageSelect', function () {
        return {
            restrict: 'E',
            template: '<select type="text" class="select-page" ng-model="inputPage" ng-change="selectPage(inputPage)"' +
                'style="padding:0; line-height: normal; height:15px !important; min-height:15px !important; width:40px; min-width:40px; font-size:13px; margin-bottom:0px !important;"  ng-options="item.value as item.text for item in itemsPager" ></select>',
            link: function (scope, element, attrs) {



                scope.$watch('currentPage', function (page) {
                    scope.inputPage = page;
                });

                scope.$watch('numPages', function (page) {
                    scope.itemsPager = [];

                    for (var i = 0; i < scope.numPages; i++) {
                        var item = { value: (i + 1), text: (i + 1).toString() };
                        scope.itemsPager.push(item);
                    }
                });
            }
        };
    });

    app.directive('stPaginationScroll', ['$timeout', function (timeout) {
        return {
            require: 'stTable',
            link: function (scope, element, attr, ctrl) {
                var itemByPage = 20;
                var pagination = ctrl.tableState().pagination;
                var lengthThreshold = 50;
                var timeThreshold = 400;
                var handler = function () {
                    //call next page
                    ctrl.slice(pagination.start + itemByPage, itemByPage);
                };
                var promise = null;
                var lastRemaining = 9999;
                var container = angular.element(element.parent());

                container.bind('scroll', function () {
                    var remaining = container[0].scrollHeight - (container[0].clientHeight + container[0].scrollTop);

                    //if we have reached the threshold and we scroll down
                    if (remaining < lengthThreshold && (remaining - lastRemaining) < 0) {

                        //if there is already a timer running which has no expired yet we have to cancel it and restart the timer
                        if (promise !== null) {
                            timeout.cancel(promise);
                        }
                        promise = timeout(function () {
                            handler();

                            //scroll a bit up
                            container[0].scrollTop -= 500;

                            promise = null;
                        }, timeThreshold);
                    }
                    lastRemaining = remaining;
                });
            }

        }
    }]);

    app.directive('keyEnter', function () {
        return function (scope, element, attrs) {
            element.bind("keydown keypress", function (event) {
                if (event.which === 13) {
                    scope.$apply(function () {
                        scope.$eval(attrs.keyEnter);
                    });

                    event.preventDefault();
                }
            });
        };
    });

    app.directive('jsGrid', function () {
        var directive = {};

        directive.restrict = "E";
        directive.template = '<div id="{{gridId}}"></div>';
        directive.scope = {
            rows: '=',
            gridId: '@'
        };
        directive.link = function (scope, element, attr, modelController) {

            var gridID = scope.gridId;

            $scope.$watch('rows', function (newValue) {
                var settings = Ex.GetDefaultSettingsJsGrid();

                settings.id = 'table_' + gridID,
                    settings.controller = {
                        loadData: function () {
                            var d = $.Deferred();
                            var datos = []
                            datos.push({});
                            datos.push({});
                            d.resolve(datos);
                            return d.promise();
                        }
                    };
                settings.height = "auto",
                    settings.fields = [
                        { name: "TipoTelefono", type: "text", width: 200, title: 'A' },
                        { name: "CodigoPais", type: "number", width: 200, title: 'b' },
                        { name: "Telefono", type: "text", width: 200, title: 'C' }
                    ],
                    $("#" + gridID + "").jsGrid("destroy");
                $("#" + gridID + "").jsGrid(settings);
            });


        };
        return directive;
    });

    app.directive('angucomplete', function ($parse, $http, $sce, $timeout) {
        return {
            restrict: 'EA',
            scope: {
                "id": "@id",
                "placeholder": "@placeholder",
                "selectedObject": "=selectedobject",
                "url": "@url",
                "dataField": "@datafield",
                "titleField": "@titlefield",
                "descriptionField": "@descriptionfield",
                "imageField": "@imagefield",
                "imageUri": "@imageuri",
                "inputClass": "@inputclass",
                "userPause": "@pause",
                "localData": "=localdata",
                "searchFields": "@searchfields",
                "minLengthUser": "@minlength",
                "matchClass": "@matchclass"
            },
            template: '<div class="angucomplete-holder"><input id="{{id}}_value" ng-model="searchStr" type="text" placeholder="{{placeholder}}" class="{{inputClass}}" onmouseup="this.select();" ng-focus="resetHideResults()" ng-blur="hideResults()" /><div id="{{id}}_dropdown" class="angucomplete-dropdown" ng-if="showDropdown"><div class="angucomplete-searching" ng-show="searching">Searching...</div><div class="angucomplete-searching" ng-show="!searching && (!results || results.length == 0)">No results found</div><div class="angucomplete-row" ng-repeat="result in results" ng-mousedown="selectResult(result)" ng-mouseover="hoverRow()" ng-class="{\'angucomplete-selected-row\': $index == currentIndex}"><div ng-if="imageField" class="angucomplete-image-holder"><img ng-if="result.image && result.image != \'\'" ng-src="{{result.image}}" class="angucomplete-image"/><div ng-if="!result.image && result.image != \'\'" class="angucomplete-image-default"></div></div><div class="angucomplete-title" ng-if="matchClass" ng-bind-html="result.title"></div><div class="angucomplete-title" ng-if="!matchClass">{{ result.title }}</div><div ng-if="result.description && result.description != \'\'" class="angucomplete-description">{{result.description}}</div></div></div></div>',

            link: function ($scope, elem, attrs) {
                $scope.lastSearchTerm = null;
                $scope.currentIndex = null;
                $scope.justChanged = false;
                $scope.searchTimer = null;
                $scope.hideTimer = null;
                $scope.searching = false;
                $scope.pause = 500;
                $scope.minLength = 3;
                $scope.searchStr = null;

                if ($scope.minLengthUser && $scope.minLengthUser != "") {
                    $scope.minLength = $scope.minLengthUser;
                }

                if ($scope.userPause) {
                    $scope.pause = $scope.userPause;
                }

                isNewSearchNeeded = function (newTerm, oldTerm) {
                    return newTerm.length >= $scope.minLength && newTerm != oldTerm
                }

                $scope.processResults = function (responseData, str) {
                    if (responseData && responseData.length > 0) {
                        $scope.results = [];

                        var titleFields = [];
                        if ($scope.titleField && $scope.titleField != "") {
                            titleFields = $scope.titleField.split(",");
                        }

                        for (var i = 0; i < responseData.length; i++) {
                            // Get title variables
                            var titleCode = [];

                            for (var t = 0; t < titleFields.length; t++) {
                                titleCode.push(responseData[i][titleFields[t]]);
                            }

                            var description = "";
                            if ($scope.descriptionField) {
                                description = responseData[i][$scope.descriptionField];
                            }

                            var imageUri = "";
                            if ($scope.imageUri) {
                                imageUri = $scope.imageUri;
                            }

                            var image = "";
                            if ($scope.imageField) {
                                image = imageUri + responseData[i][$scope.imageField];
                            }

                            var text = titleCode.join(' ');
                            if ($scope.matchClass) {
                                var re = new RegExp(str, 'i');
                                var strPart = text.match(re)[0];
                                text = $sce.trustAsHtml(text.replace(re, '<span class="' + $scope.matchClass + '">' + strPart + '</span>'));
                            }

                            var resultRow = {
                                title: text,
                                description: description,
                                image: image,
                                originalObject: responseData[i]
                            }

                            $scope.results[$scope.results.length] = resultRow;
                        }


                    } else {
                        $scope.results = [];
                    }
                }

                $scope.searchTimerComplete = function (str) {
                    // Begin the search

                    if (str.length >= $scope.minLength) {
                        if ($scope.localData) {
                            var searchFields = $scope.searchFields.split(",");

                            var matches = [];

                            for (var i = 0; i < $scope.localData.length; i++) {
                                var match = false;

                                for (var s = 0; s < searchFields.length; s++) {
                                    match = match || (typeof $scope.localData[i][searchFields[s]] === 'string' && typeof str === 'string' && $scope.localData[i][searchFields[s]].toLowerCase().indexOf(str.toLowerCase()) >= 0);
                                }

                                if (match) {
                                    matches[matches.length] = $scope.localData[i];
                                }
                            }

                            $scope.searching = false;
                            $scope.processResults(matches, str);

                        } else {
                            $http.get($scope.url + str, {}).
                                success(function (responseData, status, headers, config) {
                                    $scope.searching = false;
                                    $scope.processResults((($scope.dataField) ? responseData[$scope.dataField] : responseData), str);
                                }).
                                error(function (data, status, headers, config) {
                                    console.log("error");
                                });
                        }
                    }
                }

                $scope.hideResults = function () {
                    $scope.hideTimer = $timeout(function () {
                        $scope.showDropdown = false;
                    }, $scope.pause);
                };

                $scope.resetHideResults = function () {
                    if ($scope.hideTimer) {
                        $timeout.cancel($scope.hideTimer);
                    };
                };

                $scope.hoverRow = function (index) {
                    $scope.currentIndex = index;
                }

                $scope.keyPressed = function (event) {
                    if (!(event.which == 38 || event.which == 40 || event.which == 13)) {
                        if (!$scope.searchStr || $scope.searchStr == "") {
                            $scope.showDropdown = false;
                            $scope.lastSearchTerm = null
                        } else if (isNewSearchNeeded($scope.searchStr, $scope.lastSearchTerm)) {
                            $scope.lastSearchTerm = $scope.searchStr
                            $scope.showDropdown = true;
                            $scope.currentIndex = -1;
                            $scope.results = [];

                            if ($scope.searchTimer) {
                                $timeout.cancel($scope.searchTimer);
                            }

                            $scope.searching = true;

                            $scope.searchTimer = $timeout(function () {
                                $scope.searchTimerComplete($scope.searchStr);
                            }, $scope.pause);
                        }
                    } else {
                        event.preventDefault();
                    }
                }

                $scope.selectResult = function (result) {
                    if ($scope.matchClass) {
                        result.title = result.title.toString().replace(/(<([^>]+)>)/ig, '');
                    }
                    $scope.searchStr = $scope.lastSearchTerm = result.title;
                    $scope.selectedObject = result;
                    $scope.showDropdown = false;
                    $scope.results = [];
                    //$scope.$apply();
                }

                var inputField = elem.find('input');

                inputField.on('keyup', $scope.keyPressed);

                elem.on("keyup", function (event) {
                    if (event.which === 40) {
                        if ($scope.results && ($scope.currentIndex + 1) < $scope.results.length) {
                            $scope.currentIndex++;
                            $scope.$apply();
                            event.preventDefault;
                            event.stopPropagation();
                        }

                        $scope.$apply();
                    } else if (event.which == 38) {
                        if ($scope.currentIndex >= 1) {
                            $scope.currentIndex--;
                            $scope.$apply();
                            event.preventDefault;
                            event.stopPropagation();
                        }

                    } else if (event.which == 13) {
                        if ($scope.results && $scope.currentIndex >= 0 && $scope.currentIndex < $scope.results.length) {
                            $scope.selectResult($scope.results[$scope.currentIndex]);
                            $scope.$apply();
                            event.preventDefault;
                            event.stopPropagation();
                        } else {
                            $scope.results = [];
                            $scope.$apply();
                            event.preventDefault;
                            event.stopPropagation();
                        }

                    } else if (event.which == 27) {
                        $scope.results = [];
                        $scope.showDropdown = false;
                        $scope.$apply();
                    } else if (event.which == 8) {
                        $scope.selectedObject = null;
                        $scope.$apply();
                    }
                });

            }
        };
    });


    app.directive('numbersOnly', function () {
        return {
            require: 'ngModel',
            link: function (scope, element, attr, ngModelCtrl) {
                function fromUser(text) {
                    if (text) {
                        var transformedInput = text.replace(/[^0-9]/g, '');

                        if (transformedInput !== text) {
                            ngModelCtrl.$setViewValue(transformedInput);
                            ngModelCtrl.$render();
                        }
                        return transformedInput;
                    }
                    return '';
                }
                ngModelCtrl.$parsers.push(fromUser);
            }
        };
    });

    app.directive('decimalOnly', function () {
        return {
            restrict: 'A',
            link: function (scope, elm, attrs, ctrl) {
                elm.on('keydown', function (event) {
                    var $input = $(this);
                    var value = $input.val();
                    value = value.replace(/[^0-9\.]/g, '')
                    $input.val(value);
                    if (event.which == 64 || event.which == 16) {
                        // numbers  
                        return false;
                    } if ([8, 9, 13, 27, 37, 38, 39, 40, 110].indexOf(event.which) > -1) {
                        // backspace, enter, escape, arrows  
                        return true;
                    } else if (event.which >= 48 && event.which <= 57) {
                        // numbers  
                        return true;
                    } else if (event.which >= 96 && event.which <= 105) {
                        // numpad number  
                        return true;
                    } else if ([46, 110, 190].indexOf(event.which) > -1) {
                        // dot and numpad dot  
                        return true;
                    } else {
                        event.preventDefault();
                        return false;
                    }
                });
            }
        }
    });
    app.directive('decimalAccount', function () {
        return {
            restrict: 'A',
            link: function (scope, elm, attrs, ctrl) {
                elm.on('keydown', function (event) {
                    var $input = $(this);
                    var value = $input.val();
                    value = value.replace(/[^0-9\-\.]/g, '')

                    if (value.length >= 9 && value.indexOf('-') == -1) {
                        var value1 = value.substring(0, 4);
                        var value2 = value.substring(4, 9);
                        value = value1 + '-' + value2;
                    }

                    $input.val(value);
                    if (event.which == 64 || event.which == 16) {
                        // numbers  
                        return false;
                    } if ([8, 9, 13, 27, 37, 38, 39, 40, 110].indexOf(event.which) > -1) {
                        // backspace, enter, escape, arrows  
                        return true;
                    } else if (event.which >= 48 && event.which <= 57) {
                        // numbers  
                        return true;
                    } else if (event.which >= 96 && event.which <= 105) {
                        // numpad number  
                        return true;
                    } else if ([46, 110, 189, 190].indexOf(event.which) > -1) {
                        // dot and numpad dot  
                        return true;
                    } else {
                        event.preventDefault();
                        return false;
                    }
                });
                elm.on('blur', function (event) {
                    var $input = $(this);
                    var value = $input.val();
                    value = value.replace(/[^0-9\-\.]/g, '')

                    if (value.length >= 9 && value.indexOf('-') == -1) {
                        var value1 = value.substring(0, 4);
                        var value2 = value.substring(4, 9);
                        value = value1 + '-' + value2;
                    }

                    $input.val(value);
                });
            }


        }
    });
    app.directive('decimalRequisition', function () {
        return {
            restrict: 'A',
            link: function (scope, elm, attrs, ctrl) {
                elm.on('keydown', function (event) {
                    var $input = $(this);
                    var value = $input.val();
                    value = value.replace(/[^0-9\-\.]/g, '')

                    if (value.length >= 8 && value.indexOf('-') == -1) {
                        var value1 = value.substring(0, 4);
                        var value2 = value.substring(4, 8);
                        value = value1 + '-' + value2;
                    }

                    $input.val(value);
                    if (event.which == 64 || event.which == 16) {
                        // numbers  
                        return false;
                    } if ([8, 9, 13, 27, 37, 38, 39, 40, 110].indexOf(event.which) > -1) {
                        // backspace, enter, escape, arrows  
                        return true;
                    } else if (event.which >= 48 && event.which <= 57) {
                        // numbers  
                        return true;
                    } else if (event.which >= 96 && event.which <= 105) {
                        // numpad number  
                        return true;
                    } else if ([46, 110, 189, 190].indexOf(event.which) > -1) {
                        // dot and numpad dot  
                        return true;
                    } else {
                        event.preventDefault();
                        return false;
                    }
                });
                elm.on('blur', function (event) {
                    var $input = $(this);
                    var value = $input.val();
                    value = value.replace(/[^0-9\-\.]/g, '')

                    if (value.length >= 8 && value.indexOf('-') == -1) {
                        var value1 = value.substring(0, 4);
                        var value2 = value.substring(4, 8);
                        value = value1 + '-' + value2;
                    }

                    $input.val(value);
                });
            }


        }
    });
    app.directive('restrictInput', [function () {

        return {
            restrict: 'A',
            link: function (scope, element, attrs) {
                var ele = element[0];
                var regex = RegExp(attrs.restrictInput);
                var value = ele.value;

                ele.addEventListener('keyup', function (e) {
                    if (regex.test(ele.value)) {
                        value = ele.value;
                    } else {
                        ele.value = value;
                    }
                });
            }
        };
    }]);

    app.directive('codeInput', function () {
        return {
            require: 'ngModel',
            link: function (scope, element, attr, ngModelCtrl) {
                function fromUser(text) {
                    if (text) {
                        var transformedInput = text.replace(/\`|\~|\!|\@|\$|\%|\^|\&|\*|\(|\)|\+|\=|\[|\{|\]|\}|\||\\|\'|\<|\,|\>|\?|\/|\""|\;|\:|\s/g, "");

                        if (transformedInput !== text) {
                            ngModelCtrl.$setViewValue(transformedInput);
                            ngModelCtrl.$render();
                        }
                        return transformedInput;
                    }
                    return '';
                }
                ngModelCtrl.$parsers.push(fromUser);
            }
        };
    });

    app.directive('noSpecialChar', function () {
        return {
            require: 'ngModel',
            restrict: 'A',
            link: function (scope, element, attrs, modelCtrl) {
                modelCtrl.$parsers.push(function (inputValue) {
                    if (inputValue == null)
                        return ''
                    //cleanInputValue = inputValue.replace(/[^\w\s]/gi, '');
                    cleanInputValue = inputValue.replace(/[^a-zA-ZñÑáéíóúÁÉÍÓÚüÜ\s]/gi, '');
                    if (cleanInputValue != inputValue) {
                        modelCtrl.$setViewValue(cleanInputValue);
                        modelCtrl.$render();
                    }
                    return cleanInputValue;
                });
            }
        }
    });

    app.directive('alphanumeric', function () {
        return {
            require: 'ngModel',
            restrict: 'A',
            link: function (scope, element, attrs, modelCtrl) {
                modelCtrl.$parsers.push(function (inputValue) {
                    if (inputValue == null)
                        return ''
                    //cleanInputValue = inputValue.replace(/[^\w\s]/gi, '');
                    cleanInputValue = inputValue.replace(/[^a-zA-ZñÑáéíóúÁÉÍÓÚüÜ0123456789\s]/gi, '');
                    if (cleanInputValue != inputValue) {
                        modelCtrl.$setViewValue(cleanInputValue);
                        modelCtrl.$render();
                    }
                    return cleanInputValue;
                });
            }
        }
    });

    app.directive('ngFocusOut', function ($timeout) {
        return function ($scope, elem, attrs) {
            $scope.$watch(attrs.ngFocusOut, function (newval) {
                if (newval) {
                    $timeout(function () {
                        elem[0].focusout();
                    }, 0, false);
                }
            });
        };
    });

    app.directive('expand', function () {
        function link(scope, element, attrs) {
            scope.$on('onExpandAll', function (event, args) {
                scope.expanded = args.expanded;
            });
        }
        return {
            link: link
        };
    });

    // Setup the filter
    app.filter('datetimeFormat', function () {

        // Create the return function
        // set the required parameter name to **number**
        return function (date) {

            var splitDate = ''
            var returnDate = '';

            if (typeof (date) == 'undefined' || date == null)
                return '';

            if (date.length > 0) {
                splitDate = date.split("/");
                returnDate = new Date(splitDate[2], splitDate[1] - 1, splitDate[0]);
                var format = Ex.GetGlobalResourceValue("calendarFormat").replace("mm", "MM");

                returnDate = returnDate.format(format);
            }

            return returnDate;
        }
    });


    /*
    app.filter('startFrom', function () {
        return function (input, start) {
            return input.slice(start);
        };
    });
    */

    app.directive('upload', ['$interval', 'dateFilter', function ($interval, dateFilter) {
        return {
            scope: {
                add: '&',
                // funcion al terminar de subir el archivo
                done: '&',
                // nombre de la variable de sesion
                sesionName: '@',
                //nombre de la url del handler para subir la pagina
                url: '@',
                // objeto para guardar informacion del archivo del cliente 
                file: '=ngModel',
                //validar extension
                acceptFileTypes: '@',
                btnName: '@',
                loadingLabel: '@',
                // funcion al iniciar subir el archivo
                start: '&',
            },
            require: 'ngModel',
            controller: function () {
                var timeoutId;
                var $me = this;
                $me.name = '';
                $me.updateTime = function () {
                    $me.name = $me.name.length > 2 ? '' : $me.name + '.';
                };
                $me.endTime = function () {
                    $interval.cancel(timeoutId);
                };
                $me.starTime = function () {
                    $me.name = '';
                    timeoutId = $interval(function () {
                        $me.updateTime();
                    }, 500);
                };
            },
            controllerAs: 'ctrl',
            template:
                '<div class="control-group">' +
                '<div class="controls">' +
                '<span class="btn btn-success fileinput-button">' +
                '<i class="glyphicon glyphicon-folder-open icon-white" ></i>' +
                '<input type="file" name="file" ng-model="file">' +
                '<span ng-show="file.isBusy">&nbsp;{{loadingLabel}}&nbsp;</span>' +
                '<span ng-show="!file.isBusy">&nbsp;{{btnName}}&nbsp;</span>' +
                '</span>' +
                '</div>' +
                '</div>',
            replace: true,
            restrict: 'E',
            link: function postLink(scope, element, attrs) {

                scope.file = scope.file || {};
                scope.btnName = scope.btnName != undefined ? scope.btnName : "Buscar";
                scope.loadingLabel = scope.loadingLabel != undefined ? scope.loadingLabel : "Cargando...";
                var inputEL = $(element).find('input[type=file]')

                $(inputEL).on("change", function (event) {
                    var $path = $(this).val();
                    scope.$apply(function () {
                        scope.file.path = $path;
                        //scope.path = event.target.files[0].name;
                        //scope.fileread = event.target.files[0];
                        // or all selected files:
                        // scope.fileread = event.target.files;
                    });
                });


                //http://stackoverflow.com/questions/15549094/jquery-file-upload-plugin-how-to-validate-files-on-add
                inputEL.fileupload({
                    runSubmitOnChange: false,
                    dataType: 'json',
                    url: scope.url,
                    //acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i,                    
                    formData: { "SesionName": scope.sesionName },
                    start: function (e) {
                        var $me = this;
                        scope.$apply(function () {
                            scope.file.isBusy = true;
                            scope.ctrl.starTime();
                            $($me).attr('disabled', 'disabled');
                            $($me).parent('span').addClass('disabled');
                            scope.start();
                        });
                    },
                    add: function (e, data) {
                        var regex = RegExp(scope.acceptFileTypes || '.');
                        if (regex.test(data.files[0].name)) {
                            scope.file.inValid = false;
                            scope.$apply();
                            data.submit();
                        }
                        else {
                            var $params = {};
                            $params.e = e;
                            $params.data = data;
                            $params.data.IsInvalidFile = true;
                            //alert('Extension no valida');
                            scope.file.inValid = true;
                            scope.file.path = "";
                            scope.file.isBusy = false;
                            scope.$apply(function () {

                                if (typeof (scope.add) == 'function') {
                                    scope.add({ "e": $params.e, "data": $params.data });
                                }
                            });
                            return false;
                        }
                    },
                    fail: function (e, data) {
                        Ex.load(false);
                        var $me = this;
                        scope.$apply(function () {
                            scope.file.isBusy = false;
                            scope.ctrl.endTime();
                            $($me).removeAttr('disabled', 'disabled');
                            $($me).parent('span').removeClass('disabled');
                        });
                        alert("Error: " + data.errorThrown + " Text-Status: " + data.textStatus);
                    },
                    done: function (e, data) {
                        var $me = this;
                        var $params = {};
                        $params.e = e;
                        $params.data = data;
                        scope.$apply(function () {
                            scope.file.isBusy = false;
                            scope.ctrl.endTime();
                            $($me).removeAttr('disabled', 'disabled');
                            $($me).parent('span').removeClass('disabled');
                            scope.done({ "e": $params.e, "data": $params.data });
                        });
                    }
                });
            }
        };
    }]);


    app.directive('uploadCustom', ['$interval', 'dateFilter', function ($interval, dateFilter) {
        return {
            scope: {
                add: '&',
                // funcion al terminar de subir el archivo
                done: '&',
                // nombre de la variable de sesion
                sesionName: '@',
                //nombre de la url del handler para subir la pagina
                url: '@',
                // objeto para guardar informacion del archivo del cliente 
                file: '=ngModel',
                //validar extension
                acceptFileTypes: '@',
                btnName: '@',
                loadingLabel: '@',
                // funcion al iniciar subir el archivo
                start: '&',
            },
            require: 'ngModel',
            controller: function () {
                var timeoutId;
                var $me = this;
                $me.name = '';
                $me.updateTime = function () {
                    $me.name = $me.name.length > 2 ? '' : $me.name + '.';
                };
                $me.endTime = function () {
                    $interval.cancel(timeoutId);
                };
                $me.starTime = function () {
                    $me.name = '';
                    timeoutId = $interval(function () {
                        $me.updateTime();
                    }, 500);
                };
            },
            controllerAs: 'ctrl',
            template:
                '<div class="control-group">' +
                '<div class="">' +
                '<span class="btn btn-success fileinput-button btn-custom-fu" style="width: 100%;">' +
                //'<i class="glyphicon glyphicon-folder-open icon-white" ></i>' +
                '<input type="file" name="file" ng-model="file">' +
                '<span ng-show="file.isBusy">&nbsp;{{loadingLabel}}&nbsp;</span>' +
                '<span ng-show="!file.isBusy">&nbsp;{{btnName}}&nbsp;</span>' +
                '</span>' +
                '</div>' +
                '</div>',
            replace: true,
            restrict: 'E',
            link: function postLink(scope, element, attrs) {

                scope.file = scope.file || {};
                scope.btnName = scope.btnName != undefined ? scope.btnName : "Buscar";
                scope.loadingLabel = scope.loadingLabel != undefined ? scope.loadingLabel : "Cargando...";
                var inputEL = $(element).find('input[type=file]')

                $(inputEL).on("change", function (event) {
                    var $path = $(this).val();
                    scope.$apply(function () {
                        scope.file.path = $path;
                        //scope.path = event.target.files[0].name;
                        //scope.fileread = event.target.files[0];
                        // or all selected files:
                        // scope.fileread = event.target.files;
                    });
                });


                //http://stackoverflow.com/questions/15549094/jquery-file-upload-plugin-how-to-validate-files-on-add
                inputEL.fileupload({
                    runSubmitOnChange: false,
                    dataType: 'json',
                    url: scope.url,
                    acceptFileTypes: '/(\.|\/)(gif|jpe?g|png)$/i',
                    formData: { "SesionName": scope.sesionName },
                    start: function (e) {
                        var $me = this;
                        scope.$apply(function () {
                            scope.file.isBusy = true;
                            scope.ctrl.starTime();
                            $($me).attr('disabled', 'disabled');
                            $($me).parent('span').addClass('disabled');
                            scope.start();
                        });
                    },
                    add: function (e, data) {
                        var regex = RegExp(scope.acceptFileTypes || '.');
                        if (regex.test(data.files[0].name.toLowerCase())) {
                            scope.file.inValid = false;
                            scope.$apply();
                            data.submit();
                        }
                        else {
                            var $params = {};
                            $params.e = e;
                            $params.data = data;
                            $params.data.IsInvalidFile = true;
                            //alert('Extension no valida');
                            scope.file.inValid = true;
                            scope.file.path = "";
                            scope.file.isBusy = false;
                            scope.$apply(function () {

                                if (typeof (scope.add) == 'function') {
                                    scope.add({ "e": $params.e, "data": $params.data });
                                }
                            });
                            return false;
                        }
                    },
                    fail: function (e, data) {
                        Ex.load(false);
                        var $me = this;
                        scope.$apply(function () {
                            scope.file.isBusy = false;
                            scope.ctrl.endTime();
                            $($me).removeAttr('disabled', 'disabled');
                            $($me).parent('span').removeClass('disabled');
                        });
                        alert("Error: " + data.errorThrown + " Text-Status: " + data.textStatus);
                    },
                    done: function (e, data) {
                        var $me = this;
                        var $params = {};
                        $params.e = e;
                        $params.data = data;
                        scope.$apply(function () {
                            scope.file.isBusy = false;
                            scope.ctrl.endTime();
                            $($me).removeAttr('disabled', 'disabled');
                            $($me).parent('span').removeClass('disabled');
                            scope.done({ "e": $params.e, "data": $params.data });
                        });
                    }
                });
            }
        };
    }]);

    app.directive("exEmbed", ["$compile", function ($compile) {
        var directive = {};

        directive.restrict = "E";
        directive.require = "ngModel";

        directive.template = function (element, attr) {
            var height = "80vh";
            var width = "100%";
            if (attr.maxHeight != null)
                height = attr.maxHeight;
            if (attr.maxWidth != null)
                width = attr.maxWidth;

            var template = '<embed src={{path}} style="width: ' + width + ';height: ' + height + '" />';


            return template;
        };
        directive.link = function (scope, element, attrs, ngModelController) {
            scope.path = "";
            scope.mediaType = "";

            ngModelController.$formatters.push(function (value) {
                //var sitePath = utility.fnGetSitePath();
                //sitePath = sitePath.substring(0, sitePath.length - 1);
                scope.path = "";
                var template = "";
                if (value != null) {
                    scope.path = value.replace(/\\/g, "/");
                    scope.path = scope.path.replace('~', '');
                    //scope.path = sitePath + scope.path;
                    var extension = scope.path.split('.').pop();
                    var height = "100%";
                    var width = "100%";

                    switch (extension.toLowerCase()) {
                        case "jpg":

                            template = '<embed src="' + scope.path + '" style="width: ' + width + ';height: ' + height + '" type="image/jpeg"/>';
                            break;
                        case "pdf":

                            template = '<embed src="' + scope.path + '" style="width: ' + width + ';height: ' + height + '" type="application/pdf"/>';
                            break;
                        case "png":

                            template = '<embed src="' + scope.path + '" style="width: ' + width + ';height: ' + height + '" type="image/png"/>';
                            break;
                        case "aspx":
                            template = '<embed src="' + scope.path + '" style="width: ' + width + ';height: ' + height + '"  type="application/pdf" />';
                            break;

                        default: break;
                    }


                    element.html(template).show();
                    $compile(element.contents())(scope);

                }


                // return value;
            });

        };
        return directive;
    }]);



    app.directive('uiTable', ["$compile", "$timeout", function ($compile, $timeout) {
        var directive = {};
        directive.require = ['uiTable'];

        directive.scope = {
            uiTable: '=?',
            rootCtrl: '=?'
        };


        //directive.transclude = true;

        directive.link = function (scope, element, attrs, controllers, transclude) {


            var ctrl = controllers[0];

            if (scope.control == null) {
                scope.control = {};
            }

            scope.$watchCollection("uiTable",
                function (newValue, oldValue) {
                    scope.Rows = newValue;
                    scope.AuxRows = newValue;
                    if (ctrl.fixedCheckScroll != null) {
                        ctrl.fixedCheckScroll();
                    }
                }
            );


            //transclude(scope, function (clone, scope) {
            //    element.append(clone);
            //});
        };

        directive.controllerAs = "smartCtrl";

        directive.controller = ["$scope",
            function (scope) {
                var ctrl = this;
                ctrl.columns = [];
                ctrl.addColum = function (column) {
                    if (_.findIndex(ctrl.columns, ["data", column.fieldName]) < 0) {
                        ctrl.columns.push(column);
                    }
                };

            }
        ]

        return directive;

    }]);

    app.directive('stFixed', ['stConfig', '$timeout', function (config, $timeout) {
        return {
            require: ['uiTable'],
            template: function (element, attr) {
                element.removeAttr("height");
                element.addClass("jsgrid");

                //element.addClass("dataTables_scroll");
                //element.addClass("smart-table-wraper");

                //$("> table", element).addClass("fixed");

                var hasFooter = $("> table >tfoot", element).length > 0;

                //crea el head body y footer
                var divHead = $("<div>", {
                    "class": 'jsgrid-grid-header jsgrid-header-scrollbar'
                });

                var divBody = $("<div>", {
                    "class": 'jsgrid-grid-body'
                });

                divBody.css("height", attr.height);

                var divFooter = $("<div>", {
                    "class": 'jsgrid-grid-footer jsgrid-footer-scrollbar'
                });

                var head = element.find("table").first();

                var body = head.clone();
                $("> thead", body).remove();
                $("> tfoot", body).remove();
                $("> tbody", head).remove();
                divBody.append(body);

                var footer = head.clone();
                $("> thead", footer).remove();
                $("> tbody", footer).remove();
                $("> tfoot", head).remove();

                divFooter.append(footer);
                divHead.append(head);

                //$("> tfoot > tr ", footer).append($('<td class="tdScroll" style="width:5px">')); 
                //$("> thead > tr ", head).append($('<th class="tdScroll" style="width:5px">'));
                //$("> tbody > tr ", body).append($('<td class="tdScroll" style="width:5px">'));

                $("> thead > tr", head).addClass("jsgrid-header-row");
                $("> tbody > tr", body).addClass("jsgrid-row");


                element.append(divHead);
                element.append(divBody);
                element.append(divFooter);

            },
            link: function (scope, element, attrs, ctrls) {
                var ctrlTable = ctrls[0];

                var colFixed = attrs.colFixed == null ? 0 : parseInt(attrs.colFixed);
                var elementPosX = element.position().left;

                ///registra else scroll si el body hace escroll entonces else header y body también
                var head = $(".jsgrid-grid-header", element);
                //$(".dataTables_scrollHead").height($(".dataTables_scrollHead")[0].clientHeight - 20);
                var footer = $(".jsgrid-grid-footer ", element);
                var body = $(".jsgrid-grid-body ", element);

                ctrlTable.$body = body;
                ctrlTable.headHeight = head.height();

                $(".jsgrid-grid-body ", element).on("scroll", function (e) {
                    head.scrollLeft(e.currentTarget.scrollLeft);
                    footer.scrollLeft(e.currentTarget.scrollLeft);
                });
                //fin scroll

                ctrlTable.fixedCheckScroll = function () {
                    $timeout(function () {
                        var bodyHeight = body.height();
                        var tableHeight = $(">table", body).height();
                        if (tableHeight < bodyHeight) {
                            element.addClass("hidden-scroll-td");
                        } else {
                            element.removeClass("hidden-scroll-td");
                        }
                    }, 0);
                }

                function setWidhts() {
                    //obtiene el tamaño del head;
                    ctrlTable.headHeight = head.height();

                    var elementWidth = element.width();
                    if (elementWidth === 0) {
                        return;
                    }

                    var columnwidths = 0;

                    var columnwidths2 = _.each(ctrlTable.columns, function (col) {
                        var widthValue = parseFloat(col.width);

                        widthValue = isNaN(col.width) ? 0 : col.width;

                        columnwidths = columnwidths + widthValue

                    });
                    if (elementWidth < columnwidths) {
                        $("> table", head).width(columnwidths - 1);
                        $("> table", body).width(columnwidths - 1);
                        $("> table", footer).width(columnwidths - 1);
                        body.removeClass("hidden-hor-scroll");
                        _.each(ctrlTable.columns, function (col) {
                            col.calculatedWidth = col.width;
                        });

                    } else {
                        //$("> table", head).width(elementWidth - 20);
                        //$("> table", body).width(elementWidth - 20);
                        //$("> table", footer).width(elementWidth - 20);
                        $("> table", head).css('width', '');
                        $("> table", body).css('width', '');
                        $("> table", footer).css('width', '');
                        _.each(ctrlTable.columns, function (col) {
                            col.calculatedWidth = (col.width / columnwidths) * (elementWidth);
                        });
                        body.removeClass("hidden-hor-scroll");
                        //body.addClass("hidden-hor-scroll"); 
                    }

                    var tables = $("> > table", element);
                    tables.each(function (index, table) {
                        $("colgroup", $(table)).remove();
                        var colGroup = $("<colgroup>");
                        for (var i = 0; i < ctrlTable.columns.length; i++) {
                            var td = $("<col>");
                            td.width(ctrlTable.columns[i].calculatedWidth);
                            colGroup.append(td);
                        }
                        colGroup.append($('<col style="width:17px">'));
                        $(table).append(colGroup);

                    });

                }

                setWidhts();
            }
        };
    }]);

    //UI-uiField directiva que liga los campos a una propiedad de un objeto
    app.directive('uiField', ["$filter", function ($filter) {
        var directive = {};
        var order = 1;
        directive.require = ['?^uiTable'];
        directive.restrict = "A";
        directive.link = function (scope, elem, attrs, controllers) {

            var config = {} //new UiField(null, $filter);
            //config.fieldName = attrs.uiField;
            config.headerText = elem.text().trim();
            config.template = attrs.template != null;
            //config.visible = attrs.visible !== "false";
            //config.exportable = attrs.exportable !== "false";
            config.width = attrs.width == null ? null : parseFloat(attrs.width);
            //config.required = attrs.required != null;
            //config.className = attrs.className;
            //config.datatype = attrs.datatype;
            config.sortable = attrs.sortable !== "false";
            //config.maxLength = attrs.maxLength;
            //config.order = attrs.order == null ? order++ : parseInt(attrs.order);
            //config.colspan = 1;

            var nodeName = elem.prop("nodeName");
            config.columnIndex = $('> ' + nodeName, elem.parent()).index(elem);

            //if (attrs.source != null) {
            //    config.source = attrs.source;
            //}

            //if (attrs.filter != null) {
            //    var params = attrs.filter.split(':');
            //    var name = params[0];
            //    params.splice(0, 1);
            //    config.filter =
            //    {
            //        name: name,
            //        params: params
            //    }
            //}

            //if (config.source != null || config.filter != null) {
            //    config.customFormat = true;
            //}

            //if (config.template) {
            //    config.defaultContent = elem.html();
            //    config.headerText = attrs.title != null ? attrs.title : "";
            //    elem.text(config.headerText);
            //    config.sortable = false;
            //}


            if (controllers != null) {
                for (var i = 0; i < controllers.length; i++) {
                    if (controllers[i] == null) {
                        continue;
                    }
                    if (controllers[i].addColum != null) {
                        controllers[i].addColum(config);
                    }
                    if (controllers[i].addCell != null) {
                        controllers[i].addCell(config);
                    }
                }
            }
        };
        return directive;
    }]);


    app.directive('exAutocomplete', function ($http, $timeout) {
        var directive = {};

        directive.require = 'ngModel';

        directive.restrict = "E";

        directive.template = function (element, attr) {
            var placeHolder = attr.hasOwnProperty("placeholder") ? attr.placeholder : "";
            var theme = attr.hasOwnProperty("theme") ? attr.placeholder : "bootstrap";
            var appendToBody = false;
            var idProperty = attr.hasOwnProperty("showId") ? "item[idProp]" + " - " : "";
            var estilos = attr.hasOwnProperty("class") ? attr.class : "";
            var isIE = /*@cc_on!@*/false || !!document.documentMode;

            if (isIE)
                appendToBody = false;
            else
                appendToBody = attr.hasOwnProperty("appendToBody");

            var template = '<div>' +
                '<ui-select ng-model="itemSelected.selected" theme="' + theme + '" style="width: 85%; display: inline-block"' +
                'on-select="setValue($item)" uis-open-close="onOpenClose(isOpen)" ng-if="cleanButton"' +
                ' append-to-body="' + appendToBody + '">' +
                '<ui-select-match placeholder="' + placeHolder + '">' +
                '{{$select.selected[options.displayProp] || $select.selected}}' +
                '</ui-select-match>' +

                '<ui-select-choices repeat="item in data | filter: $select.search" ' +
                'refresh="searchData($select.search)" refresh-delay="500">{{item[options.displayProp]}}' +
                '<div ng-bind-html="item[options.displayProp] | highlight: $select.search"></div> ' +
                '<small ng-bind-html="item.Description | highlight: $select.search"></small> ' +
                '</ui-select-choices>' +
                '</ui-select> ' +

                '<ui-select ng-model="itemSelected.selected" theme="' + theme + '" style="width: 100%; display: inline-block"' +
                'on-select="setValue($item)" uis-open-close="onOpenClose(isOpen)" ng-if="!cleanButton"' +
                ' append-to-body="' + appendToBody + '" class="' + estilos + '">' +
                '<ui-select-match placeholder="' + placeHolder + '">' +
                '{{$select.selected[options.displayProp] || $select.selected}}' +
                '</ui-select-match>' +

                '<ui-select-choices repeat="item in data | filter: $select.search" ' +
                'refresh="searchData($select.search)" refresh-delay="500">{{item[options.displayProp]}}' +
                '<div ng-bind-html="item[options.displayProp] | highlight: $select.search"></div> ' +
                '<small>{{item.Description}}</small> ' +
                '</ui-select-choices>' +
                '</ui-select> ' +

                '<button type="button" ng-click="cleanInput($item)" class="btn btn-default" ng-if="cleanButton"' +
                'style="border: none !important; padding: 4px; display:inline-block;vertical-align:top">' +
                '<span class="glyphicon glyphicon-remove"></span>' +
                '</button>' +
                '</div>';

            return template;
        }

        directive.scope = {
            options: "=",
            onSelect: "&?",
            item: "=?",
            parameters: "=?"
        };

        directive.link = function ($scope, element, attrs, modelController) {
            var $scrollParent = $(element).closest(".scroll-parent");

            $scope.cleanButton = attrs.hasOwnProperty("cleanButton");

            $scope.setValue = function (item) {
                modelController.$setViewValue(item[$scope.options.idProp]);

                if ($scope.onSelect) {
                    $scope.onSelect({ optionSelected: item });
                }

                if (attrs.hasOwnProperty("width")) {
                    var $divResult = $(element).find("div.ui-select-match");
                    $divResult.css("width", attrs.width);
                }
            }

            $scope.cleanInput = function () {
                //JVillarreal, se modifica funcion para que considere onSelect al realizar un clean
                var item = $scope.itemSelected;
                $scope.itemSelected.selected = null;
                modelController.$setViewValue(item[$scope.options.idProp]);

                if ($scope.onSelect) {
                    $scope.onSelect({ optionSelected: item });
                }
            }

            $scope.onOpenClose = function (isOpen) {
                if (isOpen) {
                    $scrollParent.css("overflow-y", "visible");
                } else {
                    $scrollParent.css("overflow-y", "auto");
                }
            }

            modelController.$formatters.push(function (modelValue) {
                if (modelValue) {
                    var idProperty = $scope.options.idProp;
                    $scope.itemSelected.selected = $scope.item;
                    $scope.itemSelected.selected[idProperty] = modelValue;

                    $timeout(function () {
                        modelController.$setViewValue(modelValue);
                    }, 0);

                } else {
                    $scope.itemSelected.selected = null;
                    modelController.$setViewValue(null);
                }
            });
        };

        directive.controller = ["$scope", "$http", function ($scope, $http) {
            $Ex.Http = $http;
            $scope.itemSelected = {};
            var searchLetters = $scope.options.hasOwnProperty("searchLetters") && !isNaN($scope.options.searchLetters) ?
                $scope.options.searchLetters : 0;

            $scope.searchData = function (text) {
                if (text || (searchLetters > 0 && text.length === searchLetters)) {
                    try {
                        Ex.load(true);
                        var data = $scope.parameters ? $scope.parameters : {};
                        data.TextoBusqueda = text;
                        $Ex.Execute($scope.options.methodName, data, function (response) {
                            $scope.data = response.d;
                        });
                    } catch (ex) {
                        Ex.mensajes(ex.message, 4);
                        Ex.load(false);
                    }
                } else if (text === "" || (searchLetters > 0 && text.length < searchLetters)) {
                    $scope.data = [];
                }
            };
        }];
        return directive;
    });

    app.directive('exFileupload', function ($http, $location) {
        var directive = {};
        directive.restrict = "E";
        directive.require = "ngModel";
        directive.templateUrl = "../templates/FileUpload.html";
        directive.scope = {
            options: "=",
            parameters: "=?",
            label: "@?",
            labelButton: "@",
            onSuccess: "&?",
            onBeforeUpload: "&?",
            onCompleteAll: "&?",
            openFile: "&?",
            item: "=?",
            imageButton: "@?",
            downloadButton: "@?"
        };

        directive.link = function ($scope, element, attrs, modelController) {
            var $input = element.find("input[type=file]");
            $scope.isMultiple = attrs.hasOwnProperty("multiple");

            $scope.isInsideTable = element.closest("td").length > 0;

            $scope.uploader.onSuccessItem = function (fileItem, response, status, headers) {
                $input.val(null);
                $scope.uploader.clearQueue();
                $scope.fileName = "";

                if (response.Error) {
                    $scope.fileName = "";
                    Ex.mensajes(response.Error);
                } else {
                    $scope.fileName = fileItem.file.name;

                    if ($scope.onSuccess) {
                        $scope.onSuccess({ fileItem: fileItem, response: response, status: status, headers: headers });
                    }

                    if ($scope.item) {
                        for (var property in response) {
                            if (response.hasOwnProperty(property)) {
                                $scope.item[property] = response[property];
                            }
                        }
                    }
                }

                modelController.$setViewValue($scope.fileName);
            };

            $scope.remove = function () {
                element.find("input[type=file]").val(null);
                $scope.fileName = "";
                modelController.$setViewValue("");
            };

            modelController.$formatters.push(function (modelValue) {
                $scope.fileName = modelValue;
                return modelValue;
            });
        };

        directive.controller = ["$scope", "$http", "FileUploader", function ($scope, $http, fileUploader) {
            $scope.openInInput = $scope.hasOwnProperty("openFile");
            $scope.hideInput = $scope.options.hasOwnProperty("hideInput") && $scope.options.hideInput;

            var maxFileSize = !$scope.options.hasOwnProperty("maxFilesize") || isNaN($scope.options.maxFilesize) ?
                20 : parseInt($scope.options.maxFilesize);

            var validExtensions = $scope.options.hasOwnProperty("validExtensions") ? $scope.options.validExtensions : "";

            $scope.uploader = new fileUploader($scope.options);

            $scope.uploader.filters.push({
                name: 'maxFileSize',
                fn: function (item, options) {
                    var tamanioValido = (item.size / 1000000) < maxFileSize;
                    if (!tamanioValido) {
                        var errorMessage = Ex.GetGlobalResourceValue("msgMaxFileSize").replace("{0}", maxFileSize);
                        Ex.mensajes(errorMessage);
                    }
                    return tamanioValido;
                }
            });

            $scope.uploader.filters.push({
                name: 'extensionsAccepted',
                fn: function (item, options) {
                    validExtensions = validExtensions.replace(/[\.\s]/g, '');
                    var extensionsAccepted = validExtensions.split(",");
                    var fileName = item.name;
                    var fileExtension = fileName.substring(fileName.lastIndexOf(".") + 1);
                    var extensionAccepted = true;
                    if (validExtensions && !_.includes(extensionsAccepted, fileExtension)) {
                        var errorMessage = Ex.GetGlobalResourceValue("msgInvalidaExtension").replace("{0}", validExtensions);
                        Ex.mensajes(errorMessage);
                        extensionAccepted = false;
                    }
                    return extensionAccepted;
                }
            });

            $scope.uploader.onAfterAddingFile = function (fileItem) {
                var totalArchivos = this.queue.length;
            };

            $scope.uploader.onBeforeUploadItem = function (item) {
                if ($scope.onBeforeUpload) {
                    $scope.onBeforeUpload({ item: item });
                }

                item.parameters = {};
                var parameters = $scope.parameters ? $scope.parameters : {};
                item.parameters = _.defaults(item.parameters, parameters);
                item.formData = [item.parameters];
                $("#loading").addClass("empresa-loader");
            };

            $scope.uploader.onCompleteAll = function () {
                if ($scope.onCompleteAll) {
                    $scope.onCompleteAll();
                }
                $("#loading").removeClass("empresa-loader");
            };

            $scope.openFileFromInput = function () {
                $scope.openFile();
            };

        }];
        return directive;
    });

    app.directive('menuLateral', function ($http, $location) {
        var directive = {};

        directive.restrict = "E";
        directive.templateUrl = "Menu.html";
        directive.scope = true;

        directive.link = function (scope, element, attrs) {
            $Ex.Http = $http;
            scope.menus = [];
            var esInicio = $location.absUrl().indexOf("Inicio.aspx") >= 0;

            if (esInicio) {
                try {
                    Ex.load(true);
                    $Ex.Execute("GetMenu", {}, function (response) {
                        scope.menus = response.d;
                    });
                } catch (ex) {
                    Ex.mensajes(ex.message, 4);
                    Ex.load(false);
                }
            }

            $("body").on("click", ".lateral-menu a", function () {
                var $menu = $(this).closest(".lateral-menu");
                var $submenu = $menu.find("ul");

                if ($submenu.hasClass("in")) {
                    $submenu.removeClass("in");
                    $menu.removeClass("active");
                } else {
                    $(".nav-second-level").removeClass("in");
                    $menu.removeClass("active");
                    $submenu.addClass("in");
                    $menu.addClass("active");
                }
            });
        };
        return directive;
    });
    app.directive('stRatio', function () {
        return {
            link: function (scope, element, attr) {
                var ratio = +(attr.stRatio);

                element.css('width', ratio + '%');

            }
        };
    });
    app.directive('ionCheckbox', [function () {
        return {
            restrict: 'E',
            replace: true,
            require: '?ngModel',
            transclude: true,
            template:
                '<label class="item item-checkbox">' +
                '<div class="checkbox checkbox-input-hidden disable-pointer-events">' +
                '<input type="checkbox">' +
                '<i class="checkbox-icon"></i>' +
                '</div>' +
                '<div class="item-content disable-pointer-events" ng-transclude></div>' +
                '</label>',
            compile: function (element, attr) {
                var input = element.find('input');
                angular.forEach({
                    'name': attr.name,
                    'ng-value': attr.ngValue,
                    'ng-model': attr.ngModel,
                    'ng-checked': attr.ngChecked,
                    'ng-disabled': attr.ngDisabled,
                    'ng-true-value': attr.ngTrueValue,
                    'ng-false-value': attr.ngFalseValue,
                    'ng-change': attr.ngChange,
                    'ng-required': attr.ngRequired,
                    'required': attr.required
                }, function (value, name) {
                    if (angular.isDefined(value)) {
                        input.attr(name, value);
                    }
                });
                var checkboxWrapper = element[0].querySelector('.checkbox');
                //checkboxWrapper.classList.add('checkbox-' + $ionicConfig.form.checkbox());
            }
        };
    }]);


    app.directive("searchableMultiselect", function ($timeout) {
        return {
            templateUrl: '../Pages/Menu/searchableMultiselect.html',
            restrict: 'AE',
            scope: {
                displayAttr: '@',
                selectedItems: '=',
                allItems: '=',
                readOnly: '=',
                addItem: '&',
                removeItem: '&'
            },
            link: function (scope, element, attrs) {
                element.bind('click', function (e) {
                    e.stopPropagation();
                });

                scope.width = element[0].getBoundingClientRect();

                scope.updateSelectedItems = function (obj) {
                    var selectedObj;
                    for (i = 0; typeof scope.selectedItems !== 'undefined' && i < scope.selectedItems.length; i++) {
                        if (scope.selectedItems[i][scope.displayAttr].toUpperCase() === obj[scope.displayAttr].toUpperCase()) {
                            selectedObj = scope.selectedItems[i];
                            break;
                        }
                    }
                    if (typeof selectedObj === 'undefined') {
                        scope.addItem({ item: obj });
                    } else {
                        scope.removeItem({ item: selectedObj });
                    }
                };

                scope.isItemSelected = function (item) {
                    if (typeof scope.selectedItems === 'undefined') return false;

                    var tmpItem;
                    for (i = 0; i < scope.selectedItems.length; i++) {
                        tmpItem = scope.selectedItems[i];
                        if (typeof tmpItem !== 'undefined'
                            && typeof tmpItem[scope.displayAttr] !== 'undefined'
                            && typeof item[scope.displayAttr] !== 'undefined'
                            && tmpItem[scope.displayAttr].toUpperCase() === item[scope.displayAttr].toUpperCase()) {
                            return true;
                        }
                    }

                    return false;
                };

                scope.commaDelimitedSelected = function () {
                    var list = "";
                    angular.forEach(scope.selectedItems, function (item, index) {
                        list += item[scope.displayAttr];
                        if (index < scope.selectedItems.length - 1) list += ', ';
                    });
                    return list.length ? list : "Sin elementos Seleccionados";
                }
            }
        }
    });

    app.directive('exHighchart', ["util", function (util) {
        var directive = {};

        directive.restrict = "A";
        directive.scope = {
            chart: "=",
            header: '@?',
            type: '@',
            yTitle: '@?',
            xTitle: '@?',
            options: '=?'
        };

        directive.link = function ($scope, element, attr, modelController) {
            var chartOptions = {
                allowPointSelect: true,
                cursor: "pointer",
                labelEnabled: true,
                dataLabelsFormat: "{point.percentage:.1f} %",
                tooltipPercentaje: false,
                size: "80%",
                innerSize: '40%',
                showInLegend: true,
                xFontSize: "12px",
                yAllowDecimals: true,
                yMin: 0,
                legend: {
                    align: 'right',
                    verticalAlign: 'middle',
                    layout: 'vertical',
                    itemStyle: {
                        fontSize: '16x'
                    }
                },
                columnDepth: 100,
                alpha: 2,
                beta: 10,
                viewDistance: 0,
                depth: 60,
                connectorShape: 'fixedOffset',
                distance: 30,
                stacking: 'normal',
                dataLabels: {}
            }

            $scope.options = $scope.options ? $scope.options : {};

            chartOptions = _.defaults($scope.options, chartOptions);

            var optionsChart = chartOptions.chart ? chartOptions.chart : {};
            var chart = {
                type: $scope.type,
                options3d: {
                    enabled: chartOptions.is3d,
                    alpha: chartOptions.alpha,
                    beta: chartOptions.beta,
                    viewDistance: chartOptions.viewDistance,
                    depth: chartOptions.depth
                }
            };

            chart = _.defaults(optionsChart, chart);

            var titleOptions = chartOptions.title ? chartOptions.title : {};
            var title = {
                text: $scope.header
            };

            title = _.defaults(titleOptions, title);

            var tooltip = chartOptions.is3d ?
                {
                    headerFormat: '<b>{point.key}</b><br>',
                    pointFormat: '<span style="color:{series.color}">\u25CF</span> {series.name}: {point.percentage:.1f} %'
                } : $scope.type === "pie" ?
                    {
                        headerFormat: '',
                        pointFormat: '<b>{point.name}</b>: ${point.y:,.2f}'
                    } :
                    {
                        headerFormat: '',
                        pointFormat: '{series.name}</span>: <b>{point.y}</b> ({point.percentage:.0f}%)<br/>'
                    };

            tooltip.headerFormat = chartOptions.headerFormat !== undefined ? chartOptions.headerFormat : tooltip.headerFormat;
            tooltip.pointFormat = chartOptions.pointFormat !== undefined ? chartOptions.pointFormat : tooltip.pointFormat;

            //Opciones adicionales
            var setOptions = {
                lang: {
                    decimalPoint: '.',
                    thousandsSep: ','
                },
                colors: ['#35649E', '#4079bf', '#3887A9', '#3C9FB3', '#44B5C1', '#53C6B1', '#64C0CB', '#7892D2', '#82AFD5', '#8CD9D8']
            };

            $scope.chart.open = function (data) {

                var series = $scope.type === "pie" || !chartOptions.categories
                    ? [
                        {
                            data: data,
                            size: chartOptions.size,
                            innerSize: chartOptions.innerSize,
                            showInLegend: chartOptions.showInLegend
                        }
                    ]
                    : data;

                Highcharts.setOptions(setOptions);

                Highcharts.chart(attr.id,
                    {
                        credits: { enabled: false },
                        chart: chart,
                        title: title,
                        yAxis: {
                            allowDecimals: chartOptions.yAllowDecimals,
                            min: chartOptions.yMin,
                            title: {
                                text: $scope.yTitle ? $scope.yTitle : ""
                            }
                        },
                        xAxis: {
                            title: {
                                text: $scope.xTitle ? $scope.xTitle : ""
                            },
                            categories: chartOptions.categories ? chartOptions.categories : null,
                            labels: {
                                skew3d: chartOptions.is3d,
                                style: {
                                    fontSize: chartOptions.xFontSize
                                }
                            },
                            type: 'category'
                        },
                        plotOptions: {
                            pie: {
                                allowPointSelect: chartOptions.allowPointSelect,
                                cursor: chartOptions.cursor,
                                dataLabels: {
                                    enabled: chartOptions.labelEnabled,
                                    format: chartOptions.dataLabelsFormat,
                                    connectorShape: chartOptions.connectorShape,
                                    distance: chartOptions.distance,
                                    style: {
                                        color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
                                    }
                                }
                            },
                            column: {
                                stacking: chartOptions.stacking,
                                depth: chartOptions.columnDepth,
                                dataLabels: chartOptions.dataLabels
                            }
                        },
                        legend: chartOptions.legend,
                        tooltip: tooltip,
                        series: series
                    });
            };

            $scope.chart.openCombinationChart = function (series, setTickAmount) {
                Highcharts.setOptions(setOptions);

                var yPrimaryAxis = { title: { text: "" } };
                var ySecondaryAxis = {
                    title: { text: "" },
                    opposite: true,
                    labels: { format: '{value} %' }
                };

                if (setTickAmount) {
                    yPrimaryAxis.type = "logarithmic";
                    yPrimaryAxis.tickAmount = 7;

                    ySecondaryAxis.tickAmount = 7;
                }

                Highcharts.chart(attr.id,
                    {
                        credits: { enabled: false },
                        title: title,
                        xAxis: {
                            categories: chartOptions.categories
                        },
                        yAxis: [
                            ySecondaryAxis,
                            yPrimaryAxis
                        ],
                        series: series
                    });
            };
        };

        return directive;
    }]);

    app.directive('uiHighchart', ["util", function (util) {
        var directive = {};

        directive.restrict = "A";
        directive.scope = {
            chart: "=",
            header: '@?',
            type: '@',
            yTitle: '@?',
            xTitle: '@?',
            options: '=?'
        };

        directive.link = function ($scope, element, attr, modelController) {
            var defaultOptions = {
                legend: {
                    enabled: true
                },
                tooltip: { enabled: true },
                yAxis: { type: "" },
                xAxis: { type: "", plotLines: [] },
                plotOptions: { column: {}, pie: {} }
            };

            $scope.options = $scope.options ? $scope.options : {};
            var chartOptions = _.defaults($scope.options, defaultOptions);

            var chart = {
                type: $scope.type
            };
            chart = _.defaults(chart, chartOptions.chart ? chartOptions.chart : {});

            var title = {
                text: $scope.header
            };
            title = _.defaults(title, chartOptions.title ? chartOptions.title : {});

            //Opciones adicionales
            var additionalOptions = {
                lang: {
                    decimalPoint: ".",
                    thousandsSep: ","
                },
                colors: ['#35649E', '#4079bf', '#3887A9', '#3C9FB3', '#44B5C1', '#53C6B1', '#64C0CB', '#7892D2', '#82AFD5', '#8CD9D8']
            };

            $scope.chart.open = function (data, xTitle, yTitle) {
                Highcharts.setOptions(additionalOptions);

                Highcharts.chart(attr.id,
                    {
                        credits: { enabled: false },
                        chart: chart,
                        title: title,
                        yAxis: {
                            title: {
                                text: yTitle !== null ? yTitle : $scope.ytitle ? $scope.ytitle : ""
                            },
                            type: chartOptions.yAxis.type
                        },
                        xAxis: {
                            title: {
                                text: xTitle !== null ? xTitle : $scope.xtitle ? $scope.xtitle : ""
                            },
                            type: chartOptions.xAxis.type,
                            plotLines: chartOptions.xAxis.plotLines,
                            categories: chartOptions.categories
                        },
                        tooltip: chartOptions.tooltip,
                        plotOptions: {
                            line: {
                                dataLabels: {
                                    enabled: true
                                },
                                enableMouseTracking: false
                            },
                            column: chartOptions.plotOptions.column,
                            pie: chartOptions.plotOptions.pie
                        },
                        legend: chartOptions.legend,
                        series: data
                    });
            };

            $scope.chart.openCombinationChart = function (series, xTitle, yTitle) {
                Highcharts.setOptions(additionalOptions);

                Highcharts.chart(attr.id,
                    {
                        credits: { enabled: false },
                        title: title,
                        xAxis: {
                            categories: chartOptions.categories
                        },
                        yAxis: {
                            title: {
                                text: yTitle !== null ? yTitle : $scope.ytitle ? $scope.ytitle : ""
                            },
                            height: chartOptions.yAxis.height,
                            top: chartOptions.yAxis.top
                        },
                        plotOptions: chartOptions.plotOptions,
                        legend: chartOptions.legend,
                        tooltip: chartOptions.tooltip,
                        series: series
                    });
            };
        };

        return directive;
    }]);

    app.directive('uiCheckboxTree', ["$timeout", "$injector", function ($timeout, $injector) {
        var directive = {};

        function TreeNode(entity) {
            var self = this;

            self.Children = [];
            self.Item = {};

            var parent = null;

            if (entity !== null) {
                angular.extend(this, entity);
            }

            if (self.allowChilds == null) {
                self.allowChilds = function () {
                    return true;
                }
            }

            self.Item.allowChilds = function () {
                return self.allowChilds();
            }

            self.hasChilds = function () {
                return _.some(self.Children, function (e) {
                    return e.Item.rowCommand !== 3; // todo util.arrayCommand.deleted;
                });
            }

            self.setParent = function (newParent) {
                parent = newParent;
            }

            self.getParent = function () {
                return parent;
            }

            var state = null;
            self.setState = function (value) {
                state = value;
            }
            self.getState = function () {
                return state;
            }
        }

        //directive.templateUrl = "app/common/directives/tree/uiEditableTree.html?ver=" + config.version;
        //$templateCache.get("common/tree/uiEditableTree.html"); //"app/modules/common/tree/uiTree.html?ver1.8";
        directive.restrict = "E";

        directive.require = ['uiCheckboxTree', 'ngModel'];


        directive.scope = {
            source: '@',
            type: '@?',
            title: '@',
            filter: '=?',
            plainDatasource: '=',
        };

        directive.templateUrl = function (elem, attrs) {
            var version = Math.floor(Date.now() / 1000);
            return (attrs.templateUrl || "../Scripts/configuracion/checkBoxTree.html") + "?ver=" + version;
        }

        directive.link = function (scope, element, attrs, controllers) {
            var ctrl = controllers[0];
            var modelController = controllers[1];

            var ids = [];



            var setModelValue = function () {
                var values = [];
                for (var i = 0; i < ids.length; i++) {
                    values.push(ids[i]);
                }
                modelController.$setViewValue(values);

            }


            scope.dragEnabled = false;

            scope.treeOptions = {
            };

            if (scope.filter == null) {
                scope.filter = {};
            }


            scope.collapseAll = function () {
                scope.$broadcast('angular-ui-tree:collapse-all');
            };

            scope.expandAll = function () {
                scope.$broadcast('angular-ui-tree:expand-all');
            };

            scope.toggle = function (scopeNode) {
                scopeNode.toggle();
            };

            var toggleChildren = function (items, checked) {
                for (var i = 0; i < items.length; i++) {
                    items[i].ticked = checked;
                    scope.toogleCheckBox(items[i]);
                }
            }

            var addOrRemoveIdItem = function (id, ticked, index) {
                if (ticked && index < 0) {
                    ids.push(id);
                }
                if (!ticked && index >= 0) {
                    ids.splice(index, 1);
                }
            }

            //revisa para sus hijos si estan seleccionados o no
            var toogleParent = function (node) {
                var tickCount = 0;
                node.indeterminate = false;
                for (var i = 0; i < node.Children.length; i++) {
                    if (node.Children[i].ticked) {
                        tickCount++;
                    }
                }

                var index = ids.indexOf(node.Item[window.config.IdVariable]);
                addOrRemoveIdItem(node.Item.Id, tickCount !== 0, index);

                if (tickCount < node.Children.length) {
                    node.ticked = false;
                }

                if (tickCount === node.Children.length) {
                    node.ticked = true;
                } else if (tickCount > 0) {
                    node.indeterminate = true;
                }

                var parent = node.getParent();
                if (parent != null) {
                    toogleParent(parent);
                }

            }

            scope.toogleCheckBox = function (node, fromFormater) {
                var item = node.Item;
                var index = ids.indexOf(item[window.config.IdVariable]);

                addOrRemoveIdItem(item.Id, node.ticked, index);

                toggleChildren(node.Children, node.ticked);

                var parent = node.getParent();
                if (parent != null) {
                    toogleParent(parent);
                }

                if (!fromFormater) {
                    setModelValue();
                }
            };




            scope.root = new TreeNode();

            scope.$watch("source", function (newValue, oldValue) {
                if (newValue != null) {
                    ctrl.loadData();
                }
            });

            scope.$watch("filter", function (newValue, oldValue) {
                if (newValue != null && scope.source != null) {
                    ctrl.loadData();
                }
            });

            var childrens = [];

            var generateTree = function (data, parentId, level, parent) {
                var result = [];
                var items = _.where(data, { "ParentId": parentId });
                for (var i = 0; i < items.length; i++) {
                    var item = new TreeNode({ Item: items[i], Level: level });
                    item.setParent(parent);
                    item.Children = generateTree(data, items[i].Id, level + 1, item);
                    result.push(item);
                    if (item.Children.length === 0) {
                        childrens.push(item);
                    }
                }
                return result;
            }

            var setTicks = function () {
                for (var i = 0; i < childrens.length; i++) {
                    var node = childrens[i];
                    node.ticked = ids.indexOf(node.Item.Id) >= 0;
                    var parent = node.getParent();
                    if (parent != null) {
                        toogleParent(parent);
                    }
                }
            }

            scope.$watch("plainDatasource", function (newValue, oldValue) {
                childrens = [];
                if (newValue != null) {
                    scope.root.Item = { name: 'Root' }
                    scope.root.Children = generateTree(newValue, 0, 0);
                    setTicks();
                    $timeout(function () {
                        scope.$broadcast('angular-ui-tree:collapse-all');
                    }, 0);
                }
            });



            //cuando cambia el modelo setea los valores
            modelController.$formatters.push(function (modelValue) {
                ids.length = 0;
                if (modelValue != null) {
                    for (var i = 0; i < modelValue.length; i++) {
                        ids.push(modelValue[i]);
                    }
                    setTicks();
                }
                return modelValue;
            });




        };

        directive.controller = ["$scope", function (scope) {
            var ctrl = this;

        }];

        return directive;
    }]);

    app.directive('formDisabled', ["$timeout", function ($timeout) {
        return {
            scope: {
                form: "="
            },
            link: function (scope, element, attr, ngModelCtrl) {
                scope.form.disableForm = function (formDisabled) {
                    $timeout(function () {
                        var elements = $(element).find(":input:not(.readonly,.no-disabled, [ng-disabled],[type='search'])");
                        var hiddenElements = $(element).find(".hide-if-disabled, button:not(.no-disabled)");

                        var inputElements = $(element).find("input:not([money], [maxlength])");
                        var moneyInputs = $(element).find("input[money]");

                        elements.each(function (index, item) {
                            $(item).prop("disabled", formDisabled);
                        });

                        hiddenElements.each(function (index, item) {
                            $(item).toggle(!formDisabled);
                        });

                        inputElements.each(function (index, item) {
                            $(item).attr('maxlength', '100');
                        });

                        moneyInputs.each(function (index, item) {
                            $(item).attr('maxlength', '14');
                        });
                    }, 0);
                };
            }
        };
    }]);

    app.directive('tablaCartera', function () {
        return {
            templateUrl: "../templates/TablaCartera.html",
            scope: {
                primerColumna: "@",
                columnas: "=",
                datos: "="
            }
        };
    });

    app.directive('tablaCalidadDias', function () {
        return {
            templateUrl: "../templates/TablaCalidadDias.html",
            scope: {
                titulos: "=",
                datos: "="
            },
            controller: ["$scope", "util", function (scope, util) {
                scope.meses = util.getMonthArray(false, true);

                scope.mesesDuplicados = [];
                for (var i = 1; i <= 24; i++) {
                    var mesId = i === 1 ? 1 : i % 2 === 0 ? i / 2 : (i + 1) / 2;
                    var indiceTitulo = i === 1 || i % 2 !== 0 ? 0 : 1;
                    var diasCalidad = (indiceTitulo === 0 ? "Dias" : "Calidad") + mesId;
                    scope.mesesDuplicados.push({ Indice: indiceTitulo, DiasCalidad: diasCalidad });
                }
            }]
        };
    });

    app.directive('customDisabled', ["$timeout", function ($timeout) {
        return {
            scope: {
                customDisabled: "="
            },
            link: function (scope, element, attr, ngModelCtrl) {
                scope.$watch('customDisabled', function (newVal, oldVal) {
                    var $li = element.find("li");
                    if (newVal.disabled) {
                        $li.css("pointer-events", "none");
                    } else {
                        $li.css("pointer-events", "auto");
                    }
                }, true);
            }
        };
    }]);

    app.directive('additionalFields', function () {
        var directive = {};

        directive.restrict = "A";
        directive.scope = {
            additionalFields: "="
        };

        directive.link = function (scope, element, attrs) {
            var $celda = element.closest("td");
            var openElement = $celda.find("i");

            if (attrs.hasOwnProperty("closeElement")) {
                $("#" + attrs.closeElement).on("click", function (e) {
                    element.hide();
                });
            }

            $("body").on("click", function (e) {
                var position = $(this).position();
                element.toggle();
            });

            $("body").on("click", function (e) {
                if (!$(e.target).closest(openElement).length > 0 && !$(e.target).closest(".body-filter").length > 0) {
                    element.hide();
                }
            });
        };
        return directive;
    });

    app.directive('rubroActivity', function (enums) {
        var directive = {};

        directive.restrict = "A";
        directive.templateUrl = "../templates/RubroActivity.html?V001";
        directive.transclude = true;
        directive.scope = {
            rubroActivity: "=",
            titulo: "@",
            nombre: "@",
            nota: "@",
            calcularMontos: "&?",
            cuentas: "=?",
            activity: "=?",
            subrubroActivity: "="
        };

        directive.link = function (scope, element, attrs) {
            scope.lblObjetivos = Ex.GetResourceValue("lblObjetivos");
            scope.lblResultadosClaveFinales = Ex.GetResourceValue("lblResultadosClaveFinales");
            scope.lblIndicadorTotalCanal = Ex.GetResourceValue("lblIndicadorTotalCanal");
            scope.lblUm = Ex.GetResourceValue("lblUm");
            scope.lblActual = Ex.GetResourceValue("lblActual");
            scope.lblObjetivo = Ex.GetResourceValue("lblObjetivo");
            scope.lblNuevoObjetivo = Ex.GetResourceValue("lblNuevoObjetivo");
            scope.lblNumeroPromociones = Ex.GetResourceValue("lblNumeroPromociones");
            scope.lblHerramientaMedicion = Ex.GetResourceValue("lblHerramientaMedicion");
            scope.lblFuerzaVentasEmpresa = Ex.GetResourceValue("lblFuerzaVentasEmpresa");
            scope.lblNotaObjetivoConcurso = Ex.GetResourceValue("lblNotaObjetivoConcurso");
            scope.lblFuerzaVentasExterna = Ex.GetResourceValue("lblFuerzaVentasExterna");
            scope.lblFolioNomina = Ex.GetResourceValue("lblFolioNomina");
            scope.lblCargoQueAplica = Ex.GetResourceValue("lblCargoQueAplica");
            scope.lblNumeroPersonas = Ex.GetResourceValue("lblNumeroPersonas");
            scope.lblNumeroPremios = Ex.GetResourceValue("lblNumeroPremios");
            scope.lblIncentivo = Ex.GetResourceValue("lblIncentivo");
            scope.lblFechaInicioFin = Ex.GetResourceValue("lblFechaInicioFin");
            scope.lblCuentaPuc = Ex.GetResourceValue("lblCuentaPuc");
            scope.lblNoAplica = Ex.GetResourceValue("lblNoAplica");
            scope.lblSeleccionar = Ex.GetGlobalResourceValue("lblSeleccionar");
            scope.lblCostoTotalLinea = Ex.GetResourceValue("lblCostoTotalLinea");

            scope.fuerzasVentaExterna = [
                { TipoVentaExternaId: 1, Nombre: "Nota Crédito" }, { TipoVentaExternaId: 2, Nombre: "Orden Servicio" }
            ];
            scope.tiposIndicador = TipoIndicadorInfo;
            scope.unidadesMedida = UnidadMedidaInfo;
            scope.cargos = PerfilFuncionalInfo;
            scope.tiposPop = TipoPopInfo;
            scope.esPromocion = scope.nombre === "Promocion";
            scope.esConcurso = scope.nombre === "Concurso";
            scope.esOtros = scope.nombre === "Otros";
            scope.esPop = scope.nombre === "Pop";
            scope.esOs = scope.nombre === "Os";
            scope.esSNP = scope.subrubroActivity === "SNP";
             
            scope.expandir = function () {
                scope.rubroActivity.Expandido = !scope.rubroActivity.Expandido;
            };

            scope.agregarObjetivo = function () {
                scope.rubroActivity.Objetivos =
                    scope.rubroActivity.hasOwnProperty("Objetivos") ? scope.rubroActivity.Objetivos : [];

                scope.rubroActivity.NumerosObjetivo =
                    scope.rubroActivity.hasOwnProperty("NumerosObjetivo") ? scope.rubroActivity.NumerosObjetivo : [];

                var objetivos = _.where(scope.rubroActivity.Objetivos, { Eliminar: false });
                var numeroObjetivo = objetivos.length + 1;

                var objetivo = {
                    // RubroId: enums.rubros[scope.nombre],
                    RubroId: scope.activity.TipoActivityId === 4 ? 7 : enums.rubros[scope.nombre],
                    NumeroObjetivo: numeroObjetivo,
                    TipoFuerzaId: 1,
                    Eliminar: false
                };

                if (scope.esConcurso)
                    objetivo.Fecha = null;

                scope.rubroActivity.Objetivos.push(objetivo);

                scope.rubroActivity.NumerosObjetivo.push(numeroObjetivo);
            };

            scope.quitarObjetivo = function (objetivo, index) {
                if (objetivo.hasOwnProperty("ObjetivoId"))
                    objetivo.Eliminar = true;
                else
                    scope.rubroActivity.Objetivos.splice(index, 1);

                scope.rubroActivity.NumerosObjetivo = [];

                var objetivos = _.where(scope.rubroActivity.Objetivos, { Eliminar: false });
                _.each(objetivos, function (item, index) {
                    item.NumeroObjetivo = index + 1;
                    scope.rubroActivity.NumerosObjetivo.push(item.NumeroObjetivo);
                });

                if (scope.esConcurso)
                    scope.calcularImporte();
            };

            scope.agregarObjetivoFVE = function () {
                scope.rubroActivity.ObjetivosFVE =
                    scope.rubroActivity.hasOwnProperty("ObjetivosFVE") ? scope.rubroActivity.ObjetivosFVE : [];

                scope.rubroActivity.NumerosObjetivo =
                    scope.rubroActivity.hasOwnProperty("NumerosObjetivo") ? scope.rubroActivity.NumerosObjetivo : [];

                var objetivos = _.where(scope.rubroActivity.ObjetivosFVE, { Eliminar: false });
                var numeroObjetivo = objetivos.length + 1;

                var objetivo = {
                    // RubroId: enums.rubros[scope.nombre],
                    RubroId: scope.activity.TipoActivityId === 4 ? 7 : enums.rubros[scope.nombre],
                    NumeroObjetivo: numeroObjetivo,
                    TipoFuerzaId: 2,
                    Eliminar: false
                };

                if (scope.esConcurso)
                    objetivo.Fecha = null;

                scope.rubroActivity.ObjetivosFVE.push(objetivo);

                scope.rubroActivity.NumerosObjetivo.push(numeroObjetivo);
            };

            scope.quitarObjetivoFVE = function (objetivo, index) {
                if (objetivo.hasOwnProperty("ObjetivoId"))
                    objetivo.Eliminar = true;
                else
                    scope.rubroActivity.ObjetivosFVE.splice(index, 1);

                scope.rubroActivity.NumerosObjetivo = [];

                var objetivos = _.where(scope.rubroActivity.ObjetivosFVE, { Eliminar: false });
                _.each(objetivos, function (item, index) {
                    item.NumeroObjetivo = index + 1;
                    scope.rubroActivity.NumerosObjetivo.push(item.NumeroObjetivo);
                });

                if (scope.esConcurso)
                    scope.calcularImporte();
            };


            scope.cambiarFormaConcurso = function () {
                // scope.rubroActivity.TipoVentaExternaId = null;
                // scope.rubroActivity.Detalle = [];

                scope.calcularImporte();
            };

            scope.limpiarDetalleConcurso = function () {
                scope.rubroActivity.Detalle = [];

                scope.rubroActivity.EsSellIn = scope.rubroActivity.TipoVentaExternaId === 1;
                scope.rubroActivity.EsSellOut = scope.rubroActivity.TipoVentaExternaId === 1;

                scope.calcularMontos();
            };

            scope.calcularImporte = function () {
                var objetivos = _.where(scope.rubroActivity.Objetivos, { Eliminar: false });
                var objetivosFVE = _.where(scope.rubroActivity.ObjetivosFVE, { Eliminar: false });

                if (objetivos.length == 0 && objetivosFVE.length == 0) {
                    scope.rubroActivity.Importe = 0;
                    scope.rubroActivity.ImporteFVQ = 0;
                    scope.rubroActivity.ImporteFVE = 0;
                }

                var importe = 0;
                if (objetivos.length > 0) {
                    _.each(objetivos, function (objetivo) {
                        objetivo.CostoTotal = (isNaN(objetivo.Incentivo) ? 0 : objetivo.Incentivo) * (isNaN(objetivo.NumeroPremios) ? 0 : objetivo.NumeroPremios);
                    });

                    importe = _.reduce(objetivos, function (valor, objetivo) {
                        //valor = valor + (isNaN(objetivo.Incentivo) ? 0 : objetivo.Incentivo);
                        return valor + objetivo.CostoTotal;
                    }, 0);
                }


                var importeFVE = 0;
                if (objetivosFVE.length > 0) {
                    _.each(objetivosFVE, function (objetivoFVE) {
                        objetivoFVE.CostoTotal = (isNaN(objetivoFVE.Incentivo) ? 0 : objetivoFVE.Incentivo) * (isNaN(objetivoFVE.NumeroPremios) ? 0 : objetivoFVE.NumeroPremios);
                    });

                    importeFVE = _.reduce(objetivosFVE, function (valor, objetivoFVE) {
                        //valor = valor + (isNaN(objetivo.Incentivo) ? 0 : objetivo.Incentivo);
                        return valor + objetivoFVE.CostoTotal;
                    }, 0);
                }

                // Individuales: 
                scope.rubroActivity.ImporteFVQ = importe.toFixed(2);
                scope.rubroActivity.ImporteFVE = importeFVE.toFixed(2);

                var importeTotal = importe + importeFVE;

                scope.rubroActivity.Importe = +importeTotal.toFixed(2);


                scope.calcularMontos();
            };

            scope.tituloObjetivoVisible = function () {

                if (scope.rubroActivity !== undefined) {
                    var esVentas = scope.usuario != null && scope.usuario.EsVentas;

                    return scope.rubroActivity.TipoPopId !== 1 && scope.activity.TipoActivityId != 4 &&
                        (!scope.esConcurso ||
                            scope.rubroActivity.TipoFuerzaId === 1 || !scope.activity.PuedeModificar || esVentas);
                }
            };

            scope.concursoModificable = function () {
                return scope.activity.PuedeModificar || scope.activity.PuedeReenviar;
            };

            scope.premiosModificable = function () {
                return scope.activity.PuedeModificar || scope.rubroActivity.TipoFuerzaId === 1 && scope.activity.PuedeReenviar || scope.activity.PuedeEvaluarVentaExterna;
            };
        };
        return directive;
    });

    app.directive('rubroDetalle', function (enums) {
        var directive = {};

        directive.restrict = "E";
        directive.templateUrl = "../templates/RubroDetalle.html";
        directive.scope = {
            rubro: "=",
            nombre: "@",
            calcularMontos: "&",
            cuentas: "=?",
            activity: "=?",
            superfiltro: "="
        };

        directive.link = function (scope, element, attrs) {
            scope.lblEmpresa = Ex.GetResourceValue("lblEmpresa");
            scope.lblFormaPago = Ex.GetResourceValue("lblFormaPago");
            scope.lblDescripcion = Ex.GetResourceValue("lblDescripcion");
            scope.lblProveedor = Ex.GetResourceValue("lblProveedor");
            scope.lblCantidad = Ex.GetResourceValue("lblCantidad");
            scope.lblPrecioUnitario = Ex.GetResourceValue("lblPrecioUnitario");
            scope.lblPrecioTotal = Ex.GetResourceValue("lblPrecioTotal");
            scope.lblMoneda = Ex.GetResourceValue("lblMoneda");
            scope.lblCostoMoneda = Ex.GetResourceValue("lblCostoMoneda");
            scope.lblUm = Ex.GetResourceValue("lblUm");
            scope.lblFechaQueSeRequiere = Ex.GetResourceValue("lblFechaQueSeRequiere");
            scope.lblFechaEntragaEstimada = Ex.GetResourceValue("lblFechaEntragaEstimada");
            scope.lblCuentaPuc = Ex.GetResourceValue("lblCuentaPuc");
            scope.lblSeleccionar = Ex.GetGlobalResourceValue("lblSeleccionar");

            scope.empresas = EmpresaInfo;
            scope.formaPagos = FormaPagoInfo;
            scope.proveedores = ProveedorInfo;
            scope.unidadesMedida = UnidadMedidaInfo;
            scope.monedas = MonedaInfo;
            scope.subrubros = SubRubroInfo;
            scope.SuperFiltro = { Marcas: [] };

            scope.fechaActual = new Date(FechaInfo[0].Anio, FechaInfo[0].Mes, FechaInfo[0].Dia);

            scope.esConcurso = scope.nombre === "Concurso";
            scope.esOtros = scope.nombre === "Otros";
            scope.esOs = scope.nombre === "Os";
            scope.esSNP = scope.nombre === "SNP";

            scope.SuperFiltro.Marcas = _.pluck(scope.Marcas, 'id').join(",");

            scope.proveedoresOptions = { idProp: "ProveedorId", displayProp: "Nombre", methodName: "GetProveedores" };
            scope.articuloOptions = { idProp: "ArticuloId", displayProp: "Articulo", methodName: "GetArticulos" };

            scope.productoOptions = { idProp: "ProductoId", displayProp: "Producto", methodName: "GetProductos" };

            scope.agregar = function () {
                var numeroObjetivo = scope.rubro.NumerosObjetivo != null ? scope.rubro.NumerosObjetivo[0] : null;

                var _subRubroId = 0;
                var _rubroId = 0;
                if (scope.esSNP) {
                    var tmp = _.where(scope.subrubros, { SubRubro: scope.nombre });
                    _subRubroId = tmp[0].SubrubroId;
                    _rubroId = tmp[0].RubroId;
                }

                var detalle = {
                    RubroId: scope.activity.TipoActivityId === 4 ? 7 : (scope.esSNP ? _rubroId :enums.rubros[scope.nombre])
                    , SubRubroId: _subRubroId
                    , NumeroObjetivo: numeroObjetivo
                    , Importe: 0, Eliminar: false,
                    NombreArchivo: '',
                    RutaArchivo: '',
                    EsNuevoItem: true
                };
                scope.SuperFiltro.Marcas = _.pluck(scope.activity.Marcas, 'id').join(",");
                scope.rubro.Detalle.push(detalle);
            };

            scope.setProveedor = function (selected, item, index) {
                scope.activity['Os'].Detalle[index].Proveedor = selected.Proveedor;
                scope.activity['Os'].Detalle[index].ProveedorId = selected.ProveedorId;
                scope.activity['Os'].Detalle[index].Nombre = selected.Proveedor;
                item.Nombre = selected.Proveedor;
                item.Proveedor = selected.Proveedor;
                item.ProveedorId = selected.ProveedorId;
                item.CheckBox = false;
                item.ItemModificado = true;
            };

            scope.limpiarRow = function (item) {
                console.log(item.ProveedorId);
                item.ProveedorId = null;
                console.log(item.ProveedorId);
            };

            scope.quitar = function (item, index) {
                if (item.hasOwnProperty("DetalleId")) {
                    item.Eliminar = true;
                } else {
                    if (scope.esOs || scope.SNP) {
                        item.Eliminar = true;
                        item.ItemModificado = true;
                        item.CheckBox = false;
                    } else {
                        scope.rubro.Detalle.splice(index, 1);
                    }
                }
                scope.calcularMontos();
            };

            scope.validarReqProveedor = function (item, index) {
                //scope.rubro.ReqProveedorId = item.CheckBox ? item.ProveedorId : 0;
                if (_.where(scope.rubro.Detalle, { CheckBox: true }).length === 0) {
                    scope.rubro.ReqProveedorId = 0;
                } else {
                    scope.rubro.ReqProveedorId = item.ProveedorId;
                }
            };

            scope.calcularPrecioTotal = function (item) {
                item.CheckBox = false;
                if (item.MonedaId == 1) {
                    item.CostoMoneda = 1;
                }
                if (item.MonedaId == null) {
                    item.CostoMoneda = 0;
                }

                /*RUBRO OTROS*/
                if (item.RubroId == 4 && item.MonedaId != null && item.MonedaId != undefined && item.MonedaId > 1)
                    item.CostoMoneda = 1;
 
                // validamos si es un sub rubro SNP * para sumar por activity * 
                if (scope.esSNP) {
                    item.CostoMoneda = 1;
                    item.MonedaId = 1;
                }
                
                if (item.Cantidad != null && item.Precio != null && item.CostoMoneda !=null) { 
                    item.Importe = +(item.Cantidad * item.Precio * item.CostoMoneda).toFixed(2);
                    
                    scope.calcularMontos();
                    item.ItemModificado = true;
                }
            };

            scope.campoHabilitado = function () {
                return scope.activity.PuedeModificar || scope.activity.PuedeReenviar;
            };

            scope.fileParameters = { Folder: Ex.GetResourceValue("folderArchivos") };

            scope.fileOptions = {
                url: "../Codes/UploadFile.ashx",
                autoUpload: true,
                maxFilesize: Ex.GetResourceValue('maxFileSize'),
                validExtensions: Ex.GetResourceValue('validExtensions'),
                puedeEliminar: true
            };

            scope.setParametros = function (response, item) {
                item.UID = response.UID;
                item.RutaArchivo = response.RutaArchivo;
                item.EsArchivoNuevo = response.EsNuevo;
            };

            scope.abrirDocumento = function (item) {
                $Ex.Execute("AbrirDocumento", item, function (response, isInvalid) {
                    if (response.d) {
                        window.location = "DownLoadPage.aspx?d=" + getRandom();
                    }
                    else {
                        Ex.mensajes(Ex.GetResourceValue("msgArchivoNoEncontrado"));
                    }
                });
            };

        };
        return directive;
    });
})();


