/// <reference path="Magna.CommonModule.js" />
/// <reference path="jquery.js" />
/// <reference path="jQuery.MaskedInputs.js" />

window["Magna"] = window["Magna"] || {};
Magna.Constraints = Magna.Constraints || {};

Magna.Constraints.Required = {
    Numeric: false,
    MinLength: 1,
    GlobalMessagePattern: Ex.GetGlobalResourceValue('CampoRequerido') == '' ? 'El campo °human-name° es requerido' : Ex.GetGlobalResourceValue('CampoRequerido'), // "El campo °human-name° es requerido.",
    TooltipMessagePattern: Ex.GetGlobalResourceValue('ToolTipCampoRequerido') == '' ? 'Este campo es requerido' : Ex.GetGlobalResourceValue('ToolTipCampoRequerido'), //"Este campo es requerido",
    FieldInvalidClassName: "invalid-field",
    ID: "EAB1A454-C90C-4EC8-B9EB-FA9B3F4CFD5B"
}


Magna.Constraints.RequiredGreaterThan0 = {
    Numeric: false,
    MinLength: 1,
    MinValue: 1,
    GlobalMessagePattern: Ex.GetGlobalResourceValue('CampoRequerido'), // "El campo °human-name° es requerido.",
    TooltipMessagePattern: Ex.GetGlobalResourceValue('ToolTipCampoRequerido'), //"Este campo es requerido",
    FieldInvalidClassName: "invalid-field",
    ID: "EAB1A454-C90C-4EC8-B9EB-FA9B3F4CFD5B"
}

Magna.Constraints.Day = {
    Numeric: false,
    MinValue: 1,
    Decimals: 0,
    GlobalMessagePattern: Ex.GetGlobalResourceValue('CampoRequerido'), // "El campo °human-name° es requerido.",
    TooltipMessagePattern: Ex.GetGlobalResourceValue('ToolTipCampoRequerido'), //"Este campo es requerido",
    FieldInvalidClassName: "invalid-field",
    ID: "EAB1A454-C90C-4EC8-B9EB-FA9B3F4CFD5B"
}

Magna.Constraints.Year = {
    Numeric: false,
    Decimals: 0,
    GlobalMessagePattern: Ex.GetGlobalResourceValue('CampoRequerido'), // "El campo °human-name° es requerido.",
    TooltipMessagePattern: Ex.GetGlobalResourceValue('ToolTipCampoRequerido'), //"Este campo es requerido",
    FieldInvalidClassName: "invalid-field",
    ID: "EAB1A454-C90C-4EC8-B9EB-FA9B3F4CFD5B"
}

Magna.Constraints.PositiveCurrency = {
    Numeric: true,
    MinValue: 0,
    Decimals: 2,
    Name: "Cantidades Positivas",
    GlobalMessagePattern: Ex.GetGlobalResourceValue('CampoSoloCantidadPositiva'), //"El campo °human-name° solo permite cantidades positivas.",
    TooltipMessagePattern: Ex.GetGlobalResourceValue('ToolTipCampoSoloCantidadPositiva'), //"Solo permite cantidades positivos",
    FieldInvalidClassName: "invalid-field",
    ClassName: "currency-field",
    ID: "2AEEBFD5-2375-4D7A-A6CD-0F68AC1E89F0"
};

Magna.Constraints.PositiveCurrencyGreaterThan0 = {
    Numeric: true,
    MinValue: 1,
    Decimals: 2,
    Name: "Cantidades Positivas",
    GlobalMessagePattern: Ex.GetGlobalResourceValue('CampoSoloCantidadPositiva'), //"El campo °human-name° solo permite cantidades positivas.",
    TooltipMessagePattern: Ex.GetGlobalResourceValue('ToolTipCampoSoloCantidadPositiva'), //"Solo permite cantidades positivos",
    FieldInvalidClassName: "invalid-field",
    ClassName: "currency-field",
    ID: "2AEEBFD5-2375-4D7A-A6CD-0F68AC1E89F9"
};


Magna.Constraints.PositiveCurrencyDecimal6 = {
    Numeric: true,
    MinValue: 0,
    Decimals: 6,
    Name: "Cantidades Positivas",
    GlobalMessagePattern: Ex.GetGlobalResourceValue('CampoSoloCantidadPositiva'), //"El campo °human-name° solo permite cantidades positivas.",
    TooltipMessagePattern: Ex.GetGlobalResourceValue('ToolTipCampoSoloCantidadPositiva'), //"Solo permite cantidades positivos",
    FieldInvalidClassName: "invalid-field",
    ClassName: "currency-field",
    ID: "2AEEBFD5-2375-4D7A-A6CD-0F68AC1E89F0"
};

Magna.Constraints.PositiveCurrencyDecimal6GreaterThan0 = {
    Numeric: true,
    MinValue: 1,
    Decimals: 6,
    Name: "Cantidades Positivas",
    GlobalMessagePattern: Ex.GetGlobalResourceValue('CampoSoloCantidadPositiva'), //"El campo °human-name° solo permite cantidades positivas.",
    TooltipMessagePattern: Ex.GetGlobalResourceValue('ToolTipCampoSoloCantidadPositiva'), //"Solo permite cantidades positivos",
    FieldInvalidClassName: "invalid-field",
    ClassName: "currency-field",
    ID: "2AEEBFD5-2375-4D7A-A6CD-0F68AC1E89F0"
};

Magna.Constraints.PositiveCurrencyGreaterThan0 = {
    Numeric: true,
    MinValue: 1,
    Decimals: 2,
    Name: "Cantidades Positivas",
    GlobalMessagePattern: Ex.GetGlobalResourceValue('CampoSoloCantidadPositiva'), //"El campo °human-name° solo permite cantidades positivas.",
    TooltipMessagePattern: Ex.GetGlobalResourceValue('ToolTipCampoSoloCantidadPositiva'), //"Solo permite cantidades positivos",
    FieldInvalidClassName: "invalid-field",
    ClassName: "currency-field",
    ID: "2AEEBFD5-2375-4D7A-A6CD-0F68AC1E89F0"
};

Magna.Constraints.PositiveIntegers = {
    Numeric: true,
    MinValue: 0,
    Decimals: 0,
    Name: "Enteros Positivos",
    GlobalMessagePattern: Ex.GetGlobalResourceValue('CampoSoloNumerosPositivos'), //"El campo °human-name° solo permite números positivos.",
    TooltipMessagePattern: Ex.GetGlobalResourceValue('ToolTipCampoSoloNumerosPositivos'), //"Solo permite números positivos",
    FieldInvalidClassName: "invalid-field",
    ClassName: "integer-field",
    ID: "B9AD62F1-DFB1-4765-8A3E-0567D6426C83"
};

Magna.Constraints.PositivePercentage = {
    Numeric: true,
    MinValue: 0,
    Decimals: 3,
    Name: "Porcentaje Positivo",
    GlobalMessagePattern: Ex.GetGlobalResourceValue('CampoPorcentajePositivos'), //"El campo °human-name° solo permite porcentajes positivos.",
    TooltipMessagePattern: Ex.GetGlobalResourceValue('TooltipCampoPorcentajePositivos'), //"Solo permite porcentajes positivos",
    FieldInvalidClassName: "invalid-field",
    ClassName: "integer-field",
    ID: "C6F9AAB3-CF9C-4DD7-9298-EF38379EDDC3"
};

Magna.Constraints.PositiveIntegersGreaterThan0 = {
    Numeric: true,
    MinValue: 1,
    Decimals: 0,
    Name: "Enteros Positivos Mayores que 0",
    GlobalMessagePattern: Ex.GetGlobalResourceValue('CampoSoloNumerosPositivosMayores0'), //"El campo °human-name° solo permite números positivos mayores que 0.",
    TooltipMessagePattern: Ex.GetGlobalResourceValue('ToolTipCampoSoloNumerosPositivosMayores0'), //"Solo permite números positivos mayores que 0",
    FieldInvalidClassName: "invalid-field",
    TextInvalidClassName: "invalid-field-label",
    FieldClassName: 'numeric-field',
    DefaultValue: 1,
    ID: "67CE5F88-3CFD-43C2-9039-8CC319EA3BBA",
    DefaultValue: null
};

Magna.Constraints.PositiveIntegersGreaterThan5 = {
    Numeric: true,
    MinValue: 5,
    Decimals: 0,
    Name: "Enteros Positivos Mayores que 5",
    GlobalMessagePattern: Ex.GetGlobalResourceValue('CampoSoloNumerosPositivosMayores5'), //"El campo °human-name° solo permite números positivos mayores que 5.",
    TooltipMessagePattern: Ex.GetGlobalResourceValue('ToolTipCampoSoloNumerosPositivosMayores5'), // "Solo permite números positivos mayores que 5",
    FieldInvalidClassName: "invalid-field",
    TextInvalidClassName: "invalid-field-label",
    FieldClassName: 'numeric-field',
    DefaultValue: 5,
    ID: "889294B2-73CD-42F0-AF5A-AED39B339EB1"
};

Magna.Constraints.Email = {
    Email: true,
    Numeric: false,
    MinLength: 1,
    GlobalMessagePattern: Ex.GetGlobalResourceValue('CampoRequerido'), //"El campo °human-name° es requerido.",
    TooltipMessagePattern: Ex.GetGlobalResourceValue('CampoTipoEmail'), //"Este campo es requerido, es necesario formato de correo.",
    FieldInvalidClassName: "invalid-field",
    ID: "EAB1A454-C90C-4EC8-B9EB-FA9B3F4CFD6B"
}

Magna.Constraints.RequiredNumeric = {
    Numeric: true,
    IsString: true,
    MinValue: 1,
    Decimals: 0,
    Name: "Enteros Positivos",
    GlobalMessagePattern: Ex.GetGlobalResourceValue('CampoSoloNumerosPositivos'), //"El campo °human-name° solo permite números positivos.",
    TooltipMessagePattern: Ex.GetGlobalResourceValue('ToolTipCampoSoloNumerosPositivos'), //"Solo permite números positivos",
    FieldInvalidClassName: "invalid-field",
    ClassName: "integer-field",
    ID: "B9AD62F1-DFB1-4765-8A3E-0567D6426C83"
};

Magna.Constraints.RequiredAlphaNumeric = {
    Numeric: false,
    IsString: true,
    isAlphaNumeric: true,
    MinLength: 1,
    Decimals: 0,
    SpecialCharacters: '',
    Name: "Solo letras",
    GlobalMessagePattern: Ex.GetGlobalResourceValue('CampoRequerido'), // "El campo °human-name° es requerido.",
    TooltipMessagePattern: Ex.GetGlobalResourceValue('ToolTipCampoRequerido'), //"Este campo es requerido",
    FieldInvalidClassName: "invalid-field",
    ClassName: "integer-field",
    ID: "94EEE790-E0E2-4A34-9E19-CFC6E8A931F2"
};

Magna.Constraints.AlphaNumeric = {
    Numeric: false,
    IsString: true,
    isAlphaNumeric: true,
    MinLength: 0,
    Decimals: 0,
    SpecialCharacters: '',
    Name: "Solo letras",
    GlobalMessagePattern: Ex.GetGlobalResourceValue('CampoRequerido'), // "El campo °human-name° es requerido.",
    TooltipMessagePattern: Ex.GetGlobalResourceValue('ToolTipCampoRequerido'), //"Este campo es requerido",
    FieldInvalidClassName: "invalid-field",
    ClassName: "integer-field",
    ID: "94EEE790-E0E2-4A34-9E19-CFC6E8A931F8"
};


Magna.Constraints.Numeric = {
    Numeric: true,
    IsString: true,
    MinValue: 0,
    Decimals: 0,
    Name: "Solo Numeros",
    GlobalMessagePattern: Ex.GetGlobalResourceValue('CampoSoloNumerosPositivos'), //"El campo °human-name° solo permite números positivos.",
    TooltipMessagePattern: Ex.GetGlobalResourceValue('ToolTipCampoSoloNumerosPositivos'), //"Solo permite números positivos",
    FieldInvalidClassName: "invalid-field",
    ClassName: "integer-field",
    ID: "B9AD62F1-DFB1-4765-8A3E-0567D6426C83"
};

Magna.Constraints.RequiredAlphabetic = {
    Numeric: false,
    IsString: true,
    isAlphabetic: true,
    MinLength: 1,
    Decimals: 0,
    SpecialCharacters: '',
    Name: "Solo letras",
    GlobalMessagePattern: Ex.GetGlobalResourceValue('CampoRequerido'), // "El campo °human-name° es requerido.",
    TooltipMessagePattern: Ex.GetGlobalResourceValue('ToolTipCampoRequerido'), //"Este campo es requerido",
    FieldInvalidClassName: "invalid-field",
    ClassName: "integer-field",
    ID: "94EEE790-E0E2-4A34-9E19-CFC6E8A931F2"
};

Magna.ValidateConstraint = function (field) {

    var constraint = field.DataConstraint;
    if (constraint == null)
        return { Valid: true };


    if (field.DataConstraint.FieldInvalidClassName != null) {
        if (field.Extension == null)
            jQuery(field).removeClass(constraint.FieldInvalidClassName);
        else
            jQuery(field.Extension.Root).removeClass(constraint.FieldInvalidClassName);
    }
      
    //Verificamos si el control que estamos validando es un multiselect.... de bootstrap.
    if ($(field).parent() != null) {
        if ($(field).parent().find(".multiselect") != null) {
            $(field).parent().find(".multiselect").removeClass(constraint.FieldInvalidClassName); 
        }
    } 


    if (field.ConstraintTooltip != null) {
        field.ConstraintTooltip.Dispose();
        field.ConstraintTooltip = null;
    }

    var applyMessages = function (theField, theConstraint) {
        if (theField.DataConstraint.FieldInvalidClassName != null) {

            if (field.Extension == null)
                jQuery(field).addClass(constraint.FieldInvalidClassName);
            else
                jQuery(field.Extension.Root).addClass(constraint.FieldInvalidClassName);

            //Verificamos si el control que estamos validando es un multiselect.... de bootstrap.
            if ($(theField).parent() != null) {
                if ($(theField).parent().find(".multiselect") != null) {
                    $(theField).parent().find(".multiselect").addClass(constraint.FieldInvalidClassName);
                }
            }
        }

        var humanName = theField.getAttribute("human-name");

        if (theConstraint.TooltipMessagePattern != null) {
            if (theField.ConstraintTooltip == null) {


                var text = theConstraint.TooltipMessagePattern.replace("°human-name°", humanName);
                var textNode = document.createTextNode(text);
                var label = document.createElement("label");
                label.appendChild(textNode);
                if (theField.DataConstraint.TextInvalidClassName != null)
                    jQuery(label).addClass(theField.DataConstraint.TextInvalidClassName);

                var innerConfig = {
                    TitleBehavior: true
                };

                theField.ConstraintTooltip = new Magna.AnchoredTooltip(theField, label, innerConfig);
            }
        }

        if (theConstraint.GlobalMessagePattern == null)
            return null;

        if (humanName == null)
            return null;
        return theConstraint.GlobalMessagePattern.replace("°human-name°", humanName);
    }


    if (jQuery.trim(field.value).length === 0)
        field.value = field.DataConstraint.DefaultValue || "";


    var value = field.CustomGetValue == null ? field.GetValue() : field.CustomGetValue();
    var message;
    if (constraint.Numeric === true) {
        if (constraint.MinValue != null) {
            if (value < constraint.MinValue) {
                message = applyMessages(field, constraint);
                return { Valid: false, Message: message };
            }
        }

        if (constraint.MaxValue != null) {
            if (value > constraint.MaxValue) {
                message = applyMessages(field, constraint);
                return { Valid: false, Message: message };
            }
        }
    }
    else {
        if (constraint.MinLength != null) {
            if (value.length < constraint.MinLength) {
                message = applyMessages(field, constraint);
                return { Valid: false, Message: message };
            }
        }
        if (constraint.MinValue != null) {
            if (value < constraint.MinValue) {
                message = applyMessages(field, constraint);
                return { Valid: false, Message: message };
            }
        }

        if (constraint.Email != null) {
            if (ValidaEmail(value) == false) {
                message = applyMessages(field, constraint);
                return { Valid: false, Message: message };
            }
        }
    }
    return { Valid: true };
}

Magna.ClearConstraintStyle = function (field) {
    var constraintName = field.getAttribute("data-constraint");
    if (constraintName == null)
        return;

    var constraint = Magna.Constraints[constraintName];
    if (constraint == null)
        return;

    if (constraint.FieldInvalidClassName != null) {

        if (field.Extension == null)
            jQuery(field).removeClass(constraint.FieldInvalidClassName);
        else
            jQuery(field.Extension.Root).removeClass(constraint.FieldInvalidClassName);
    }

    //Verificamos si el control que estamos validando es un multiselect.... de bootstrap.
    if ($(field).parent() != null) {
        if ($(field).parent().find(".multiselect") != null) {
            $(field).parent().find(".multiselect").removeClass("invalid-field");
        }
    }

    if (field.ConstraintTooltip != null) {
        field.ConstraintTooltip.Dispose();
        field.ConstraintTooltip = null;
    }
}

Magna.SetConstraint = function (field) {
    var constraintName = field.getAttribute("data-constraint");
    if (constraintName == null)
        return;

    var constraint = Magna.Constraints[constraintName];
    if (constraint == null)
        return;

    var minValue = field.getAttribute("MinValue");

    if (minValue != null) {
        constraint.MinValue = minValue;
    }

    var maxValue = field.getAttribute("MaxValue");

    if (maxValue != null) {
        constraint.MaxValue = maxValue;
    }

    var toolTipValidate = field.getAttribute("ToolTipValidate");

    if (toolTipValidate != null) {
        constraint.TooltipMessagePattern = toolTipValidate;
    }

    var specialCharacters = field.getAttribute("SpecialCharacters");

    if (specialCharacters != null) {
        constraint.SpecialCharacters = specialCharacters;
    }

    var decimals = field.getAttribute("Decimals");

    if (decimals != null) {
        constraint.Decimals = decimals;
    }

    field.DataConstraint = jQuery.extend({}, constraint);



    if (jQuery.trim(field.value).length === 0)
        field.value = field.DataConstraint.DefaultValue || "";

    if (constraint.ClassName != null)
        jQuery(field).addClass(constraint.ClassName);

    if (field.CustomGetValue != null)
        return field.CustomGetValue();

    if (constraint.Numeric === true) {

        field.MaskConfig = {
            format: "numeric",
            decimals: constraint.Decimals,
        };


        if (constraint.IsString == true) {
            field.MaskConfig.SoloNumeros = true;
        }

        if (constraint.Decimals === 0) {
            if (constraint.IsString == true) {
                field.GetValue = function () {
                    return this.value;
                }
            }
            else {
                field.GetValue = function () {
                    var value = window.parseInt(jQuery(this).asNumber());
                    return window.isNaN(value) ? 0 : value;
                }
            }
        }
        else {
            field.GetValue = function () {
                var value = window.parseFloat(jQuery(this).asNumber());
                return window.isNaN(value) ? 0 : value;
            }
        }

        field.ApplyFormat = function () {
            //if (this.value != '') {
            jQuery(this).maskOnLeave(this.MaskConfig);
            //}
        }

        field.ApplyFormat();


    }
    else {

        if (constraint.isAlphabetic == true) {
            field.MaskConfig = {
                format: "alphabetic",
                decimals: constraint.Decimals,
                SpecialCharacters: constraint.SpecialCharacters,
            };

            field.ApplyFormat = function () {
                //if (this.value != '') {
                jQuery(this).maskOnLeave(this.MaskConfig);
                //}
            }

            field.ApplyFormat();
        }

        if (constraint.isAlphaNumeric == true) {
            field.MaskConfig = {
                format: "alphaNumeric",
                decimals: constraint.Decimals,
                SpecialCharacters: constraint.SpecialCharacters,
            };

            field.ApplyFormat = function () {
                //if (this.value != '') {
                jQuery(this).maskOnLeave(this.MaskConfig);
                //}
            }

            field.ApplyFormat();
        }


        field.GetValue = function () {
            return jQuery.trim(this.value);
        }

    }

    if (field.DataConstraint.FieldClassName != null)
        jQuery(field).addClass(field.DataConstraint.FieldClassName);

}
