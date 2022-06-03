(function () {
    app.controller('getTechnicalDocumentationController', ['$scope', '$http', '$location',  function ($scope, $http, $location) {
        $Ex.Http = $http;
        var documentation = this;
        
        documentation.DocumentationList = [];
        
        documentation.getDocumentation = function () {
            try {
                Ex.load(true);
                var info = {};

                if (typeof(documentation.fileName) == 'undefined' || documentation.fileName.length == 0) {
                    documentation.DocumentationList = [];
                    documentation.AuxDocumentationList = [];
                    Ex.load(false);
                    return;
                }

                //info.fileName = "JUPRailBOL.aspx.cs";
                $Ex.Execute("GetDocumentation", documentation, function (response) {
                    documentation.DocumentationList = response.d.DocumentationInfo;
                    documentation.AuxDocumentationList = response.d.DocumentationInfo;
                });
            } catch (ex) {
                Ex.mensajes(ex.Message);
                Ex.load(false);
            }
        }

        //documentations.getDocumentation();
    }]);
})();