(function () {
	var app = angular.module('enums', []);

	app.constant('enums',
		{
			tiposActivity: { General: 1, Pop: 2, Medios: 3, Idm: 4, OtrosGastos:5 },
			rubros: { Promocion: 1, NotaCredito: 2, Concurso: 3, Otros: 4, Pop: 5, Os: 6 },
			tiposElemento: { vendido: 1, regalado: 2 },
			tiposAlmacen: { preventa: 1, otrosCanales: 2, ambos: 3 },
			tiposDescuento: { importe: 1, porcentaje: 2 },
			unidadesMedida: { caja: 1, unidad: 2, display: 2 },
			estatusActivity: {
				guardado: 1,
				enAutorizacion: 2,
				pendientePublicar: 3,
				rechazado: 4,
				publicado: 5,
				enEjecucion: 6,
				proximoVencer: 7,
				cerrado: 8
			}
		});
})();