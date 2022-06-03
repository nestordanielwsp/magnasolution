using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace magnajs.Codes
{
    public enum TipoActivity
    {
        General = 1,
        Pop = 2,
        Medios = 3,
        Idm = 4
    }
    public enum Rubro
    {
        Promociones = 1,
        NotasCredito = 2,
        Concursos = 3,
        Otros = 4,
        Pop = 5,
        Os = 6,
    }
    public enum SubRubro
    {
        SNP = 1
    }
    public enum TipoFuerza
    {
        VentasEmpresa = 1,
        VentasExterna = 2
    }
    public enum TipoVentaExterna
    {
        NotaCredito = 1,
        OrdenServicio = 2
    }
    public enum TareaPendiente
    {
        AltaProyecto = 1,
        ActualizarFechaCierre = 2,
        CerrarProyecto = 3,
        AltaCodigoPromocion = 4,
        CierreCodigoPromocion = 5
    }

    public enum ProcesoRobot
    {
        PolizaMensual = 1,
        ActivityCierrePresupuesto = 2
    }

    public enum Sincronizador
    {
        ListaPrecioProducto = 17,
        ArticulosActivity=19,
        Presupuesto = 21,
        MatrizPOP=22,
        DiasFestivos=23
    }
    public enum TipoPop
    {
        Lanzamiento = 1
    }
}