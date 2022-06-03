///// <reference path="jquery-1.7.2.min.js" />
///// <reference path="jquery-ui-1.8.21.custom.js" />
///// <reference path="json2.js" />
///// <reference path="jquery.validate.js" />
///// <reference path="jquery.tmpl.min.js" />

(function ($) {

    function setValue(container, object, path) {
        //    ///	<summary>
        //    /// Binds an object to all html controls contained on the dialog control. 
        //    /// Example: 
        //    /// if we have an object plant.ID = 1; plant.Description ="Test", and in the dialog control we have two textboxes
        //    /// <input type="text" data-PropertyValue="ID"/> and <input type="text" data-PropertyValue="Description"/>
        //    /// and call the function Bind(plant,'') it sets to the first textBox the value of 1 and to the second textBox the value of "Test"
        //    /// </summary>
        var controls = $("[name]", container);
        controls.each(function (i) {
            try {
                var $ControlToSave = $(this);
                var propertyValues = $ControlToSave.attr("name").split(".");
                var finalValue = object[propertyValues[0]];

                for (i = 1; i < propertyValues.length; i++) {
                    finalValue = finalValue[propertyValues[i]];
                }

                if (finalValue != undefined) {
                    var type = typeof (finalValue);
                    if (type == "object") {
                        $ControlToSave.val(JSON.stringify(finalValue));
                    }
                    else {
                        $ControlToSave.val(finalValue);
                    }
                }
            }
            catch (ex) {

            }
        });
    };

    $.fn.objectValue = function (value) {

        var result = new Object();

        if (value != null) {
            this.each(function () {
                setValue($(this), value);
            });
        } else {
            $("[name]", this.first()).each(function () {
                SaveToObject(result, $(this).attr("name").split("."), $(this).val());
            });
        }

        return result;
    };
})(jQuery);


(function ($) {


    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////// DATA LINK ////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    $.widget("ui.DataLink", {
        ////////////////////////////////////////////// INITIALIZE////////////////////////////////////////////////////
        options: {
            //Initial object contains the collection wich be used to populate the table
            Data: null,
            //Propertie values that will be attached to all items created
            DefaultProperties: {},
            ////////////////////////REMOTE FUNCTIONS////////////////////////////////////
            //Remote function wich will be called to update, edit or delete a single record on the server.
            UpdateServerItemUrl: '',
            //Remote function wich will be called to get data to bind the table.
            GetDataUrl: null,
            //Filter to get data function
            GetDataFilter: {},
            //When autoupdate is setted to true, attach change events to controls in order to update the values automatically on the data object
            //dont use if parent has other DataLink or Repeaters inside
            AutoUpdate: false,
            ///////////Events///////////////
            //Occurs after data is saved on server side
            //Saved,
            //Occurs after data is obtained from server side
            //Loaded,
            //Occurs when SaveToServer function has errors 
            //ErrorSaved
            //Occurs when LoadedFromServer function has errors 
            //ErrorLoaded,
            CustomWaitControl: $([])
        },
        //Initializes the widget
        _create: function () {
            var self = this;
            self._Initialize();
        },

        destroy: function () {
            this.element
    			.unbind("." + this.widgetName)
    			.removeData(this.widgetName);
            this.widget()
    			    .unbind("." + this.widgetName);
        },

        _setOption: function (option, value) {
            $.Widget.prototype._setOption.apply(this, arguments);
        },

        _Initialize: function () {
            //Initializes the variables
            var self = this;
            self.Data = self.options.Data;
            if (self.Data != null) {
                $.extend(self.Data, self.options.DefaultProperties);
                Bind(self.element, self.Data, "");
            }
            else {
                self.Data = new Object();
                $.extend(self.Data, self.options.DefaultProperties);
            }

            if (self.options.AutoUpdate) {
                //              var removeSelector = "[data-RepeaterSection=DeleteItem][RepeaterId=" + self.RepeaterId + "]";
                //                self.DataBody.off(".RemoveRepeater");
                //                self.DataBody.on("click.RemoveRepeater", removeSelector, function (event) {
                //                
                self.element.off(".DatalinkUpdate");
                self.element.on("change.DatalinkUpdate", "[data-PropertyValue]", function (event) {
                    var propertyValue = $(this).attr("data-PropertyValue");
                    var type = $(this).attr('type');
                    var value;
                    var valueText;
                    var newData = new Object();
                    if (type == 'checkbox') {
                        value = $(this).attr('checked') == 'checked';

                    }
                    else if (type == 'radio') {
                        value = $("input[type=radio]:checked", $(this)).val();
                    }
                    else if ($(this).is("select")) {
                        value = $(this).val();
                        var valueText = $(":selected", this).text();
                        SaveToObject(self.Data, $(this).attr("data-PropertyText").split("."), valueText);
                        var propertyText = $(this).attr("data-PropertyText");
                        $("[data-PropertyValue='" + propertyText + "']", self.element).each(function (i) {
                            SetValueToElement($(this), valueText);
                        });

                    }
                    else {
                        value = $(this).val();
                    }

                    if (value != null) {
                        SaveToObject(newData, $(this).attr("data-PropertyValue").split("."), value);
                        $.extend(self.Data, newData);

                        $("[data-PropertyValue='" + propertyValue + "']", self.element).each(function (i) {
                            SetValueToElement($(this), value);
                        });
                    }
                });
            }

        },

        _HandleAjaxError: function (msg) {
            var self = this;
            if (msg.responseText.toLowerCase().indexOf("unknown web method") >= 0) {
                errorMessage = "Error on Repeater plugin, controlID: " + self.ParentDiv.attr('ID') + "\n";
                errorMessage += "The web method " + self.options.UpdateServerItemUrl + " does not exists";
                alert(errorMessage);
                return;
            }
            if (msg.responseText.toLowerCase().indexOf("no web service found at") >= 0) {
                errorMessage = "Error on Repeater plugin, controlID: " + self.ParentDiv.attr('ID') + "\n";
                errorMessage += "The web service " + self.options.UpdateServerItemUrl + " does not exists";
                alert(errorMessage);
                return;
            }

            try {
                msg = Try_ParseJSON(msg.responseText);
                alert(msg.Message);
            }
            catch (err) {
                alert(msg.responseText);
            }
        },

        //PUBLIC FUNCTIONS        
        //////////////////////////////////////////////PUBLIC FUNCTIONS        ////////////////////////////////////////////////////

        LoadFromServer: function (filter) {
            var self = this;
            var filter = JSON.stringify(filter);
            var parameters = "{filter:" + filter + "}";
            if (self.options.GetDataUrl != null) {
                self.options.CustomWaitControl.CustomWait("Show");
                $.ajax({
                    type: 'POST', dataType: 'JSON', contentType: 'application/json; charset=utf-8', async: true,
                    url: self.options.GetDataUrl, data: parameters,
                    success: function (result) {
                        self.options.CustomWaitControl.CustomWait("Hide");
                        self.Data = Try_ParseJSON(result);
                        Bind(self.element, self.Data, "");
                        self._trigger('Loaded', null, { Data: self.Data });
                    },
                    error: function (msg) {
                        self.options.CustomWaitControl.CustomWait("Hide");
                        try {
                            var exception = Try_ParseJSON(msg.responseText);
                            exception.Handled = false
                            self._trigger('ErrorLoaded', null, { Data: self.Data, Exception: exception });
                            if (!exception.Handled) {
                                self._HandleAjaxError(msg);
                            }
                        }
                        catch (err) {
                            self._HandleAjaxError(msg);
                        }
                    }
                });
            }
            else {
                errorMessage = "Error on DataLink plugin, controlID: " + self.element.attr('ID') + "\n";
                errorMessage += "The parameter option GetDataUrl has not been initialized.";
                alert(errorMessage);
                return;
            }
        },

        SetDefaultProperties: function (defaultProperties) {
            this.options.DefaultProperties = defaultProperties;
        },

        // The number of elements contained in the matched element set
        ///	<summary>
        ///		Update an object on the server side.                        
        ///	</summary>
        ///	<returns type="Object.Entity,Object.Result">
        /// returns an object that the object updated (result.Entity) and flag to indicates wether the operation was succefull(result.Success)
        /// </returns>
        ///	<param name="objectUpdated" type="Object">
        ///     Object wich will be inseted, deleted or updated on the server side.
        ///	</param>
        ///	<param name="operation" type="string">
        ///     Operation ("save" or "delete")
        ///	</param>
        SaveToServer: function () {
            var self = this;
            $.extend(self.Data, self.options.DefaultProperties);
            SaveObjectFromControlValues(self.element, self.Data);
            var parameters = "{objectUpdated:" + JSON.stringify(self.Data) + "}";
            var result = new Object();
            self.options.CustomWaitControl.CustomWait("Show");
            $.ajax({
                type: 'POST', dataType: 'JSON', contentType: 'application/json; charset=utf-8', async: true,
                url: self.options.UpdateServerItemUrl, data: parameters,
                success: function (updatedEntity) {
                    self.options.CustomWaitControl.CustomWait("Hide");
                    self.Data = Try_ParseJSON(updatedEntity);
                    Bind(self.element, self.Data, "");
                    self._trigger('Saved', null, { Data: self.Data });
                },
                error: function (msg) {
                    self.options.CustomWaitControl.CustomWait("Hide");
                    //alert if error ocurrs
                    //and set result.Success=false
                    result["Success"] = false;
                    try {
                        var exception = Try_ParseJSON(msg.responseText);
                        exception.Handled = false
                        self._trigger('ErrorSaved', null, { Data: self.Data, Exception: exception });
                        if (!exception.Handled) {
                            self._HandleAjaxError(msg);
                        }
                    }
                    catch (err) {
                        self._HandleAjaxError(msg);
                    }
                }
            });

            return result;
        },

        GetData: function () {
            var self = this;
            SaveObjectFromControlValues(self.element, self.Data);
            return self.Data;
        },

        SetData: function (data) {
            var self = this;
            self.Data = data;
            Bind(self.element, self.Data, "");
        }
    });
  
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////AUTO COMPLETE/////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    $.widget("ui.CustomAutocomplete", {
        ////////////////////////////////////////////// INITIALIZE////////////////////////////////////////////////////
        options: {
            //Remote function wich will be called to get data to bind the table.
            GetDataUrl: null,
            GetByIdUrl: null,
            //Filter to get data function
            Filter: {},
            PropertyKeyName: "",
            //Controls and properties wich will be seted on select event,
            //Usage: {'fieldName1' : 'entitySelectedField1', 'fieldName2' : 'entitySelectedField2', .... }  
            CopyToControls: {},
            //ShowElements
            PropertiesToShow: [],
            DynamicFilters: [],
            MinLength: 3,
            MessageCss: "",
            ItemCss: "",
            AlternateItemCss: "",
            HeaderCss: "",
            TooManyResultsMessage: "(***solo se mostrarán los primeros 15 registros de la búsqueda***)",
            ShowHeader: false,
            AutoFocus: true,
            ButtonSearchID: '',
            
        },

        destroy: function () {

            this.element.autocomplete("destroy");

            this.element
    			.off("." + this.widgetName)
    			.removeData(this.widgetName);
            this.widget().unbind("." + this.widgetName);


        },

        _setOption: function (option, value) {
            $.Widget.prototype._setOption.apply(this, arguments);
        },

        //Initializes the widget
        _create: function () {
            var self = this;
            var pageCount;
            var lastSelectedItem = null;
            var lastItems = null;

            self.TableWidth = 0;
            

            self.element.on("change." + this.widgetName, function (event) {

                if ($(this).val() == "") {
                    if (lastSelectedItem != null) {
                        for (var property in lastSelectedItem) {
                            if (lastSelectedItem.hasOwnProperty(property)) {
                                lastSelectedItem[property] = null;
                            }
                        }
                        self._CopyToControls(lastSelectedItem);
                        self._ClearControls();
                    }
                }
                else {
                    var count = 0;
                    for (var property in lastSelectedItem) {
                        if (lastSelectedItem[property] != null) {
                            count++;
                        }
                    }
                    if (count == 0)
                    {
                        self._CopyToControls(lastSelectedItem);
                        self._ClearControls();
                    }
                }
                
            });

            self.element.autocomplete({
                source: function (request, response) {
                    var parameters = null;
                     
                    var datosactual = (Ex.isUndefined(self.options.Filter) ? {} : self.options.Filter);

                    datosactual.TextoBusqueda = request.term;

                    if (self.options.DynamicFilters.length > 0) {
                        $.each(self.options.DynamicFilters, function (index, entity) {
                            var valor = null;
                            if ($("[Id$=" + entity.ControlID + "]").length > 0) {
                                //cuando es un combo obtenemos diferente el valor
                                if ($("[Id$=" + entity.ControlID + "]")[0].type == 'select-one') {
                                    var selectedOption = $("option:selected", $("[Id$=" + entity.ControlID + "]"));
                                    if (selectedOption.length > 0) {
                                        valor = selectedOption.val()
                                    }
                                }
                                else {
                                    valor = $("[Id$=" + entity.ControlID + "]").val();
                                }
                            }
                            datosactual[entity.PropertyName] = valor;
                        });
                    }

                   parameters = JSON.stringify({ datos: datosactual }); 

                    $.ajax({
                        url: self.options.GetDataUrl, type: 'POST',
                        dataType: "json", contentType: 'application/json; charset=utf-8', async: true,
                        data: parameters,
                        delay:500,
                        success: function (data) {
                            var result = {}

                           // result.Items = jQuery.parseJSON(data.d);
                            result.Items = data.d;
                            result.PageCount = result.Items.length;

                            if (result.Items == null || result.PageCount == null) {
                                alert("object returned in function '" + self.options.GetDataUrl + "' must have a propery named 'Items' (array of objects) and a property named PageCount");
                                return false;
                            }
                            else {
                                lastItems = result.Items;
                                pageCount = result.PageCount;
                                response($.map(result.Items, function (item) {
                                    return item;
                                }));
                            }
                        },
                        error: function (msg) {
                            self._HandleAjaxError(msg, self.options.GetDataUrl);
                        }
                    });
                },
                minLength: self.options.MinLength,
                select: function (event, ui) {
                    lastSelectedItem = ui.item;
                    if (self.options.BeforeHandleSelection != null)
                        self.options.BeforeHandleSelection(lastSelectedItem);

                    //self.element.val(lastSelectedItem[self.options.PropertyKeyName]);
                    self._CopyToControls(lastSelectedItem);
                    self._trigger('SelectedItem', event, ui.item);
                    
                    if (self.options.HandleSelection != null)
                        self.options.HandleSelection();
                    return false;
                }, 
                change: function (event, ui) {
                    if (self.options.BeforeHandleSelection != null)
                        self.options.BeforeHandleSelection(ui.item);

                    if (ui.item == null || lastSelectedItem == null) {
                        self._ClearControls();
                    }
                    /*
                    if ($("#" + nombre).val() == "" || $("#" + id).val() == "") {
                        $("#" + id).val("");
                    } 
                    */
                },
                close: function () {
                    /*
                    if ($("#" + nombre).val() == "" || $("#" + id).val() == "") {
                        $("#" + id).val("");
                    }
                    */
                },
                autoFocus: self.options.AutoFocus
            }).data("autocomplete")._renderMenu = function (ul, items) {
                
                var copyItems = [];
                if (pageCount > 15) {
                    $(" <li id='header' class='{0}'>{1}</li>".format(self.options.MessageCss, self.options.TooManyResultsMessage)).appendTo(ul);

                    for (var i = 0; i < items.length; i++) {
                        
                        if (i <= 14){
                            copyItems.push(items[i]);
                        }
                    }

                    items = null;
                    items = copyItems;
                } 

             

                self.TotalWidth = 0;

                
                    
                    var header = "<li class='{0}'>".format(self.options.HeaderCss);
                    $.each(self.options.PropertiesToShow, function (index, property) {

                        self.TotalWidth  += parseInt(property.Width);

                        header = header + " <div style='width:{0}px;float:left;' >{1}</div> ".format(
                            property.Width-5,
                            property.HeaderText
                            );

                        self.TableWidth = self.TableWidth + parseInt(property.Width);
                    });

                     header = header + "<br />";
                     header = header + "</li>";

                    
                    
                if (self.options.ShowHeader) {
                   // $(header).width(self.TotalWidth + 3).appendTo(ul);
                    $(header).appendTo(ul);
                }

                $.each(items, function (index, item) {
                    self._RenderItem(ul, item);
                });

                //$(self.DataBody).children(":even").addClass(self.options.RowCssClass);
                $("li:odd:not(#header)", ul).addClass(self.options.AlternateItemCss);
                $("li:even:not(#header)", ul).addClass(self.options.ItemCss);

                setTimeout("$('#" + ul[0].id + "').width(" + self.TotalWidth + ")", 10);

            };
//            self.element.removeClass("ui-corner-all");

        },

        ////////////////////////////////////////////// FUNCTIONS////////////////////////////////////////////////////
        _CopyToControls: function (item) {
            var self = this;
            $.each(self.options.CopyToControls, function (fieldName, entitySelectedField) {
                var elem = $(fieldName);
                if(elem.is('span')){
                    elem.html(item[entitySelectedField]);
                }
                else{
                    elem.val(item[entitySelectedField]);
                }
            });
        },
        
        _ClearControls: function () {
            var self = this;
            $.each(self.options.CopyToControls, function (fieldName, entitySelectedField) {
                var elem = $('span[id$="' + fieldName + '"]');
                elem.html("");
                elem = $('[id$="' + fieldName + '"]:not(span)');
                elem.val("");

                if (fieldName.indexOf("id$") > -1) {
                    var elem = $(fieldName);
                    elem.html("");
                    elem = $(fieldName + ':not(span)');
                    elem.val("");
                }

            });
        },

        _RenderItem: function (ul, item) {
            var self = this;
            var elements = new String();

                       

            $.each(self.options.PropertiesToShow, function (index, property) {
                elements = elements + "<span style='width:{0}px; float:left;' >{1}</span>".format(property.Width-5, item[property.PropertyName]);
            });

            return $("<li style='padding-top: 2px; padding-bottom: 2px;'  ></li>")                            
            				.data("item.autocomplete", item)
                	.append("<a> " + elements + " </a>").width("100%")
            				.appendTo(ul);

            //.append("<a style='height:98%;'> " + elements + " </a>").width(self.TotalWidth + 30)

        },

        _HandleAjaxError: function (msg, webMethod) {
            var self = this;
            var errorMessage;
            if (msg.responseText.toLowerCase().indexOf("unknown web method") >= 0) {
                errorMessage = "Error on Autocomplete plugin, controlID: " + self.element.attr('ID') + "\n";
                errorMessage += "The web method " + webMethod + " does not exists";
                alert(errorMessage);
                return;
            }
            if (msg.responseText.toLowerCase().indexOf("no web service found at") >= 0) {
                errorMessage = "Error on Autocomplete plugin, controlID: " + self.element.attr('ID') + "\n";
                errorMessage += "The web service " + webMethod + " does not exists";
                alert(errorMessage);
                return;
            }

            try {
                msg = parseJSON(msg.responseText);
                alert("Error: " + msg.Message);
            }
            catch (err) {
                alert(msg.responseText);
            }
        },
        
        setDataFilter:function (){
            var self = this;   
        }

    });
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////// COMBOBOX ////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    $.widget("ui.combobox", {
        _create: function () {
            var input,
					self = this,
                    width = this.element.width() - 32,
					select = this.element.hide(),
					selected = select.children(":selected"),
					value = selected.val() ? selected.text() : "",
					wrapper = $("<span>")
						.addClass("ui-combobox")
						.insertAfter(select);

            input = $("<input>")
					.appendTo(wrapper)
					.val(value)
					.addClass("ui-state-default")
                    .width(width)
					.autocomplete({
					    delay: 0,
					    minLength: 0,
					    source: function (request, response) {
					        var matcher = new RegExp($.ui.autocomplete.escapeRegex(request.term), "i");
					        response(select.children("option").map(function () {
					            var text = $(this).text();
					            if (this.value && (!request.term || matcher.test(text)))
					                return {
					                    label: text.replace(
											new RegExp(
												"(?![^&;]+;)(?!<[^<>]*)(" +
												$.ui.autocomplete.escapeRegex(request.term) +
												")(?![^<>]*>)(?![^&;]+;)", "gi"
											), "<strong>$1</strong>"),
					                    value: text,
					                    option: this
					                };
					        }));
					    },
					    select: function (event, ui) {
					        if (self.element.val() != ui.item.option.value) {
					            self.element.trigger("change")
					        }
					        ui.item.option.selected = true;
					        self._trigger("selected", event, {
					            item: ui.item.option
					        });
					    },
					    change: function (event, ui) {
					        if (!ui.item) {
					            var matcher = new RegExp("^" + $.ui.autocomplete.escapeRegex($(this).val()) + "$", "i"),
									valid = false;
					            select.children("option").each(function () {
					                if ($(this).text().match(matcher)) {
					                    this.selected = valid = true;
					                    this.element.change();
					                    return false;
					                }
					            });
					            if (!valid) {
					                // remove invalid value, as it didn't match anything
					                $(this).val("");
					                select.val("");
					                input.data("autocomplete").term = "";
					                return false;
					            }
					        }
					    }
					})
					.addClass("ui-widget ui-widget-content ui-corner-left");

            input.data("autocomplete")._renderItem = function (ul, item) {
                return $("<li></li>")
						.data("item.autocomplete", item)
						.append("<a>" + item.label + "</a>")
						.appendTo(ul);
            };

            $("<a>")
					.attr("tabIndex", -1)
					.attr("title", "Show All Items")
					.appendTo(wrapper)
					.button({
					    icons: {
					        primary: "ui-icon-triangle-1-s"
					    },
					    text: false
					})
					.removeClass("ui-corner-all")
					.addClass("ui-corner-right ui-button-icon")
					.click(function () {
					    // close if already visible
					    if (input.autocomplete("widget").is(":visible")) {
					        input.autocomplete("close");
					        return;
					    }

					    // work around a bug (likely same cause as #5265)
					    $(this).blur();

					    // pass empty string as value to search for, displaying all results
					    input.autocomplete("search", "");
					    input.focus();
					});
        },

        destroy: function () {
            this.wrapper.remove();
            this.element.show();
            $.Widget.prototype.destroy.call(this);
        }
    });

})(jQuery);


function GetRemoteData(remoteMethodUrl, filter) {
    var parameters = "{filter:" + filter + "}";
    var result = new Object();
    $.ajax({
        type: 'POST', dataType: 'JSON', contentType: 'application/json; charset=utf-8', async: false,
        url: remoteMethodUrl,
        data: parameters,
        success: function (updatedEntity) {
            result = Try_ParseJSON(updatedEntity);
        },
        error: function (msg) {
            throw msg.responseText;
        }
    });

    return result;
}


function Bind($Container, object, path) {
//    ///	<summary>
//    /// Binds an object to all html controls contained on the dialog control. 
//    /// Example: 
//    /// if we have an object plant.ID = 1; plant.Description ="Test", and in the dialog control we have two textboxes
//    /// <input type="text" data-PropertyValue="ID"/> and <input type="text" data-PropertyValue="Description"/>
//    /// and call the function Bind(plant,'') it sets to the first textBox the value of 1 and to the second textBox the value of "Test"
//    /// </summary>
    var controls = $("[data-PropertyValue]:not([data-repeatersection=Rows] *)", $Container);
    controls.each(function (i) {
        try {
            var $ControlToSave = $(this);
            var propertyValues = $ControlToSave.attr("data-PropertyValue").split(".");
            var finalValue = object[propertyValues[0]];

            for (i = 1; i < propertyValues.length; i++) {
                finalValue = finalValue[propertyValues[i]];
            }
            if (finalValue != undefined) {
                var type = typeof (finalValue);
                if (type == "object" && $ControlToSave.data().Repeater == null) {
                    SetValueToElement($ControlToSave, JSON.stringify(finalValue));
                }
                else {
                    SetValueToElement($ControlToSave, finalValue);
                    //if control is dropdownlist and value does not exists in options, then add value and text to the dropdownlist
                    
                    if ($ControlToSave.is("select") && $ControlToSave.val() != finalValue) {
                        var propertyText = $ControlToSave.attr("data-PropertyText").split(".");
                        var finalText = object[propertyText[0]];

                        for (i = 1; i < propertyText.length; i++) {
                            finalText = finalText[propertyText[i]];
                        }
                        if (finalText != undefined) {
                            $ControlToSave.append($("<option></option>").attr("value", finalValue).text(finalText));
                            $ControlToSave.val(finalValue);
                        }
                    }

                }

            }
        }
        catch (ex) {

        }
    });
};

function SetValueToElement($ControlToSave, value) {
    var type = $ControlToSave.attr("type");
    if (type == null) {
        type = "";
    }
    if (type.toLowerCase() == "checkbox") {
        $ControlToSave.attr("checked", value);
    }
    else if (type.toLowerCase() == "radiobuttonlist") {
        if (value != null) {
            var $SelectedRadio = $("input[type=radio][value=" + value.toString() + "]", $ControlToSave);
            var attrDisabled = $SelectedRadio.attr("disabled");
            $SelectedRadio.removeAttr("disabled");
            $SelectedRadio.click();
            if (attrDisabled != null && attrDisabled.length > 0) {
                $SelectedRadio.attr("disabled", attrDisabled);
            }
        }
    }
    else if (type.toLowerCase() == "checkboxlist") {
        var stringArray = new Array();
        for (i = 0; i < value.length; i++) {
            stringArray.push(value[i].toString());
            stringArray.sort();
        }

        $("input[type=checkbox]", $ControlToSave).each(function () {
            if (jQuery.inArray($(this).val(), stringArray) == -1) {
                $(this).removeAttr("checked");
            }
            else {
                $(this).attr("checked", "checked");
            }
//            $(this).trigger('change');
        });
    }
    else if ($ControlToSave.data().Repeater != null) {
        $ControlToSave.Repeater("SetData", value);
    }
    else if ($ControlToSave.is("span") || $ControlToSave.is("div")) {
        $ControlToSave.html(value);
    }
    else {
        if ($ControlToSave.attr("data-EmptyValue") == value) {
            $ControlToSave.val("");
        }
        else {
            $ControlToSave.val(value);
        }
//        if (triggerEventChange) {
////            $ControlToSave.trigger('change');
//        }
    }
};

String.prototype.toFixed = function(decimalNumbers) {
    return Number(this).toFixed(decimalNumbers);
};

function GetValueFromElement(element) {
    var value;
    var type = element.attr("type");
    var isNumeric = element.attr("data-IsNumeric");
    if (type == null) {
        type = "";
    }
    
    if (type.toLowerCase() == "checkbox") {
        value = element.attr('checked') == 'checked';
    }
    else if (type.toLowerCase() == "radiobuttonlist") {
        value = $("input[type=radio]:checked", element).val();
    }
    else if (element.data().Repeater != null) {
        value = element.Repeater("GetData");
    }
    else if (type.toLowerCase() == "checkboxlist") {
        value = new Array();
        $("input[type=checkbox]:checked", element).each(function () {
            value.push($(this).val());
        });
    }
    else if ((element.is("span") || element.is("div")) && $("input", element).length == 0) {
        value = element.html();
    }
    else {
        value = element.val();

        if (jQuery.trim(value) == "") {
            var value = element.attr("data-EmptyValue");
            if (value == null)
                value = "";
        }
    }

    if (isNumeric =="true"){
        //Set all non number or points as not valid characters

        var invalidCharacterPattern = new RegExp("[^\\d\\" + NumberDecimalSeparator + ")]", "g");
        value = value.replace(invalidCharacterPattern, "").replace(NumberDecimalSeparator,".");
    }

    var finalValue;

    try {
        finalValue = JSON.parse(value);
        if (typeof (finalValue) != "object") {
            finalValue = value;
        }
    }
    catch (ex) {
        finalValue = value;
    }

    return finalValue;
}


function SaveObjectFromControlValues($container, destination) {
    //Gets all controls wich has an attributed named "data-PropertyValue" and save it to the item
    $("[data-PropertyValue]:not([data-repeatersection=Rows] *)", $container).each(function (i) {
        var element = $(this);
        var propertyValue = $.trim(element.attr("data-PropertyValue")).split(".");
        var value = GetValueFromElement(element);
        SaveToObject(destination, propertyValue, value);
    });

    //Gets all controls wich has an attributed named "data-PropertyText" and save it to the item
    $("[data-PropertyText]", $container).each(function (i) {
        SaveToObject(destination, $(this).attr("data-PropertyText").split("."), $(":selected", this).text());
    });
}

function SaveToObject(entity, property, value) {
    ///	<summary>
    /// Save a value into property object. 
    /// Example: var plant = newObject(); SaveToObject(plant,'ID','4'); will create an property ID on the object plant and set it with the value = 4;
    /// at the end plant.ID has the value of 4
    ///	</summary>
    if (property.length > 1) {
        var newEntityProp = property.shift();
        var newEntity = new Object();
        if (entity[newEntityProp] != null)
            newEntity = entity[newEntityProp];

        SaveToObject(newEntity, property, value);

        entity[newEntityProp] = newEntity;
    }
    else {
        entity[property[0]] = value;
    }
};

function Remove__TypeProperty(object) {
    ///	<summary>
    ///Removes the .__type Property from an object (its necesary because deserilize function in asp.net throws an exception when object have this propery),     
    ///	</summary>
    var objectStack = new Array();
    var currentObject;
    objectStack.push(object);
    do {
        currentObject = null
        if (objectStack.length > 0) {
            currentObject = objectStack.pop();
        }
        var type = typeof (currentObject);
        if (currentObject != null && !(type == "number" || type == "string" || type == "boolean" || type == "undefined" || type == "function")) {
            if (currentObject.__type != null)
                delete currentObject.__type
            for (var property in currentObject) {
                if (currentObject.hasOwnProperty(property)) {
                    objectStack.push(currentObject[property]);
                }
            }
        }
    } while (currentObject != null || objectStack.length > 0)
}


function Try_ParseJSON(object) {
    if (typeof (object) == "string") {
        object = JSON.parse(object);
    }

    if (object.d != null)
        var object = object.d;
    Remove__TypeProperty(object);
    return object;
}


function AlertAjaxError(msg) {
    try {
        msg = Try_ParseJSON(msg.responseText);
        alert(msg.Message);
    }
    catch (err) {

        alert(msg.responseText);
    }
}

var waitItem = new Object;

function ShowWaitItem() {
    if (!waitItem.Hidden) {
        if (waitItem.IsDialog) {
            waitItem.Element.dialog("open");
        }
        else {
            waitItem.Element.show();
        }
    }
}

$.fn.clearForm = function () {
    return this.each(function () {
        var type = this.type, tag = this.tagName.toLowerCase();
        if (tag == 'form')
            return $(':input', this).clearForm();
        if (type == 'text' || type == 'password' || tag == 'textarea')
            this.value = '';
        else if (type == 'checkbox' || type == 'radio')
            this.checked = false;
        else if (tag == 'select')
            this.selectedIndex = -1;
    });
};


String.prototype.format = function () { var pattern = /\{\d+\}/g; var args = arguments; return this.replace(pattern, function (capture) { return args[capture.match(/\d+/)]; }); }