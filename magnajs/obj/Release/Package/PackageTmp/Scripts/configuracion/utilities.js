 app = angular.module("utility", []);

app.factory('util', ['$q', "$http", 'FileUploader', function ($q, $http, fileUploader) {
    var util = {};
    $Ex.Http = $http;

    var defaultOptionsMultiselect = {
        enableSearch: false,
        scrollableHeight: '200px',
        scrollable: true,
        buttonClasses: 'btn btn-multiselect',
        showCheckAll: true,
        showUncheckAll: true
    }

    util.getOptionsMultiselect = function (idProp, displayProp, optionsMultiselect) {
        optionsMultiselect = !optionsMultiselect ? {} : optionsMultiselect;
        optionsMultiselect.idProp = idProp;
        optionsMultiselect.displayProp = displayProp;

        optionsMultiselect = _.defaults(optionsMultiselect, defaultOptionsMultiselect);
        return optionsMultiselect;
    }

    util.getYearArray = function (totalYears) {
        var years = [];
        var currentYear = new Date().getFullYear();
        var year = currentYear;

        for (var i = 0; i < totalYears; i++) {
            years.unshift(year);
            year--;
        }

        return years;
    }   

    util.getMonthArray = function (endMonth, isShortName) {
        var january = Ex.GetGlobalResourceValue(isShortName ? "lblEne" : "lblEnero");
        var february = Ex.GetGlobalResourceValue(isShortName ? "lblFeb" : "lblFebrero");
        var march = Ex.GetGlobalResourceValue(isShortName ? "lblMar" : "lblMarzo");
        var april = Ex.GetGlobalResourceValue(isShortName ? "lblAbr" : "lblAbril");
        var may = Ex.GetGlobalResourceValue(isShortName ? "lblMay" : "lblMayo");
        var jun = Ex.GetGlobalResourceValue(isShortName ? "lblJun" : "lblJunio");
        var july = Ex.GetGlobalResourceValue(isShortName ? "lblJul" : "lblJulio");
        var augost = Ex.GetGlobalResourceValue(isShortName ? "lblAgo" : "lblAgosto");
        var september = Ex.GetGlobalResourceValue(isShortName ? "lblSep" : "lblSeptiembre");
        var october = Ex.GetGlobalResourceValue(isShortName ? "lblOct" : "lblOctubre");
        var november = Ex.GetGlobalResourceValue(isShortName ? "lblNov" : "lblNoviembre");
        var december = Ex.GetGlobalResourceValue(isShortName ? "lblDic" : "lblDiciembre");

        var months = [
            { Id: 1, Name: january },
            { Id: 2, Name: february },
            { Id: 3, Name: march },
            { Id: 4, Name: april },
            { Id: 5, Name: may },
            { Id: 6, Name: jun },
            { Id: 7, Name: july },
            { Id: 8, Name: augost },
            { Id: 9, Name: september },
            { Id: 10, Name: october },
            { Id: 11, Name: november },
            { Id: 12, Name: december }
        ];

        if (endMonth) {
            months = _.filter(months, function(item) {
                return item.Id <= endMonth;
            });
        }

        return months;
    }

    util.getBlueColors = function(totalColors) {
        var colors = ["#35649E", "#3887A9", "#3C9FB3", "#44B5C1", "#53C6B1", "#64C0CB",
            "#7892D2", "#35649E", "#82AFD5", "#8CD9D8", "#93DBA7", "#B6DFA0", "#ADC9E4",
            "#B6E7BC", "#C4EBC6"];

        totalColors = colors.length < totalColors ? colors.length : totalColors;

        return colors.slice(0, totalColors);
    }

    return util;
}]);