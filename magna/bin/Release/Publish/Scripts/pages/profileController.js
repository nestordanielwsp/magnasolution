 
(function () {
  'use strict';

  angular.module(appName)
      .controller('profileController', profileController); 

  function profileController($scope, $http, $rootScope,  FileUploader) {
      var service = $Ex;
      service.Http = $http;
      var vm = this; 
      vm.perfiles = []; 
      vm.usuario = {}
      var consultar = function (filtros) {
          try {
              Ex.load(true);
              var datos = vm.filtro || {};
              service.Execute('Consultar', datos, function (response) {
                  if (response.d) {
                      vm.usuario = response.d.Usuario[0];
                      vm.usuario.PathImg = response.d.Usuario[1].NombreUsuario;
                      vm.perfiles = response.d.Perfil;
                      
                  }
                  Ex.load(false)
                  vm.loading = false;

              })
          }
          catch (ex) {
              Ex.mensajes(ex.message, 4);
              Ex.load(false);
              vm.loading = false;

          }
      }
      var init = function () {
          consultar();
      }
      init();
      vm.guardar = function () {
          try {
              if (!$Ex.IsValidateRequiredFieldForm(vm.form)) {
                  vm.isValid = false;
                  return;
              }

              if ((vm.usuario.NuevoPassword || vm.usuario.NuevoPasswordValidacion) &&
                  (vm.usuario.NuevoPassword != "" || vm.usuario.NuevoPasswordValidacion != "")) {
                  if (vm.usuario.NuevoPassword != vm.usuario.NuevoPasswordValidacion) {
                      Ex.mensajes(Ex.GetResourceValue("ContrasenasNoCoinciden"), 4);
                      return;
                  } 
              }
 

              var datos = vm.usuario;
              service.Execute("Guardar", datos, function (response, isInvalid) {
                  if (isInvalid) {
                      req.form.isValid = false;
                      return;
                  }
                  if (response.d.UsuarioId) {
                      vm.usuario.UsuarioId = response.d.UsuarioId;
                      vm.usuario.Active = response.d.Active;
                      vm.usuario.UID = response.d.UID;
                      //Se limpia la contraseña
                      if (vm.usuario.NuevoPassword)
                          delete vm.usuario.NuevoPassword;
                      if (vm.usuario.NuevoPasswordValidacion)
                      delete vm.usuario.NuevoPasswordValidacion;

                      if (vm.usuario.UsuarioId == UsuarioId) {
                          consultarPathImg(vm.usuario);
                      }

                  } 
                  Ex.mensajes(Ex.GetResourceValue("msgAlertGuardar"), 1);
                  Ex.load(false);
              });
          } catch (ex) {
              Ex.mensajes(ex.message, 4);
              Ex.load(false);
          }
      }

      var consultarPathImg = function (datos) {
          try {
              var datos = datos;
              service.Execute("ConsultarRutaArchivo", datos, function (response) {
                  if (response.d) {
                      vm.usuario.PathImg = response.d;
                      $rootScope.$broadcast('ImagenPerfil', { value: vm.usuario.PathImg });
                  } else
                      $rootScope.$broadcast('ImagenPerfil', { value: "" });
              });
          } catch (ex) {
              Ex.mensajes(ex.message, 4);
              Ex.load(false);
          }
      }
      vm.removePicture = function () { 
          vm.usuario.Img = ""; 
          vm.usuario.PathImg = null; 
          vm.usuario.UID = "";  
          delete vm.usuario["Blob"];
          try { 
              service.Execute("REmoveSessionMassive", {}, function (response) { 
                  console.log(response);
              });
          } catch (ex) {
              Ex.mensajes(ex.message, 4);
              Ex.load(false);
          }
      }


      $scope.massiveConfirmationFile = {
          Data: [],
          DataError: []
      }
      $scope.massiveConfirmationAdd = function (e, data) {
          if (data.IsInvalidFile) {
              Ex.mensajes(Ex.GetResourceValue("msgInvalidExtensionFile"), 5);
          }
      }

      $scope.massiveConfirmationUploadStart = function () {
          Ex.load(true);
      }

      $scope.massiveConfirmationUploaded = function (e, data) {
          Ex.load(false);
          if (data.result.HasError) {
              Ex.mensajes(data.result.Message, 4);
              $scope.massiveConfirmationFile.path = '';
          }
          else {
              $scope.massiveConfirmationFile.information = data.result;
              if (data.result) {
                  //vistaPRevia
                  vm.usuario.Img = data.files[0].name;
                  vm.usuario.Blob = window.URL.createObjectURL(data.files[0]);
              }

              $scope.massiveConfirmationFile.DataError = data.result.DataError || [];
              $scope.massiveConfirmationFile.DataErrorAux = data.result.DataError || [];
              if ($scope.massiveConfirmationFile.DataError.length > 0) {
                  $scope.massiveConfirmationFile.HasError = true;
              }


          }
      };
  }

})();
