function calcularCURP(Nombre, ApellidoPaterno, ApellidoMaterno, FechaNacimiento, Sexo, Estado) {
    var paterno1st = ApellidoPaterno;

    paterno1st = paterno1st.replace("LAS", "");
    paterno1st = paterno1st.replace("DEL", "");

    var paterno = paterno1st.replace("LA", "");
    paterno = paterno.replace("DE", "");
    paterno = paterno.replace("Y", "");

    while (paterno[0] == " ") {
        paterno = paterno.substr(1, paterno.length - 1);
    }

    var materno1st = ApellidoMaterno;
    var materno1st = materno1st.replace("LAS", "");
    materno1st = materno1st.replace("DEL", "");
    materno1st = materno1st.replace("DE", "");

    var materno = materno1st.replace("LA", "");
    materno = materno.replace("Y", "");

    while (materno[0] == " ") {
        materno = materno.substr(1, materno.length - 1);
    }

    var nombre = Nombre;
    var op_paterno = paterno.length;
    var vocales = /^[aeiou]/i;
    var consonantes = /^[bcdfghjklmnñpqrstvwxyz]/i;

    var s1 = '';
    var s2 = '';
    var s8 = '';

    var i = 0;
    var x = true;
    var z = true;

    while (i < op_paterno) {
        if ((consonantes.test(paterno[i]) == true) & (x != false)) {
            s1 = s1 + paterno[i];
            paterno = paterno.replace(paterno[i], "");
            x = false;
        }

        if ((vocales.test(paterno[i]) == true) & (z != false)) {
            s2 = s2 + paterno[i];
            paterno = paterno.replace(paterno[i], "");
            z = false;
        }
        i++;
    }

    var ix = 0;
    var y = true;
    var nparteno = paterno.length;

    while (ix < nparteno) {
        if ((consonantes.test(paterno[ix]) == true) & (y != false)) {
            s8 = s8 + paterno[ix];
            y = false;
        }
        ix++;
    }

    //calculos apellido materno
    var maternosize = materno.length;
    var j = 1;
    var s9 = '';
    var xm = true;
    var ym = true;

    while (j < maternosize) {
        if ((consonantes.test(materno[j]) == true) && (xm != false)) {
            s9 = s9.replace(materno[j], "");
            xm = false;
        }

        if ((consonantes.test(materno[j]) == true) && (ym != false)) {
            s9 = s9 + materno[j];
            ym = false;
        }

        j++;
    }

    var nombresize = nombre.length;
    var im = 1;
    var s10 = '';
    var wx = true;
    var wz = true;

    while (im < nombresize) {

        if ((consonantes.test(nombre[im]) == true) && (wz != false)) {
            s10 = s10 + nombre[im];
            nombre = nombre.replace(nombre[im], "");
            wz = false;
        }
        im++;
    }

    var sexo = Sexo;
    if (sexo == 'HOMBRE') { sexo = 'H'; } else { sexo = 'M'; }


    var edo = Estado;

    /* Verificamos si no trae otra clave el estado */
    switch (edo) {
        case 'AGS':            edo = 'AS';            break;
        case 'BCS':            edo = 'BS';            break;
        case 'CHI':            edo = 'CH';            break;
        case 'CHS':            edo = 'CS';            break;
        case 'CMP':            edo = 'CC';            break;
        case 'COA':            edo = 'CL';            break;
        case 'COL':            edo = 'CM';            break;
        case 'DGO':            edo = 'DG';            break;
        case 'GRO':            edo = 'GR';            break;
        case 'GTO':            edo = 'GT';            break;
        case 'HGO':            edo = 'HG';            break;
        case 'JAL':            edo = 'JC';            break;
        case 'MCH':            edo = 'MN';            break;
        case 'MEX':            edo = 'MC';            break;
        case 'MOR':            edo = 'MS';            break;
        case 'NAY':            edo = 'NT';            break;
        case 'OAX':            edo = 'OC';            break;
        case 'PUE':            edo = 'PL';            break;
        case 'QRO':            edo = 'QT';            break;
        case 'SIN':            edo = 'SL';            break;
        case 'SLP':            edo = 'SP';            break;
        case 'SON':            edo = 'SR';            break;
        case 'TAB':            edo = 'TC';            break;
        case 'TLX':            edo = 'TL';            break;
        case 'TMS':            edo = 'TS';            break;
        case 'VER':            edo = 'VZ';            break;
        case 'YUC':            edo = 'YN';            break;
        case 'ZAC':            edo = 'ZS';            break;

    } 



    switch (edo) {
        case "AGUASCALIENTES": edo = "AS"; break;
        case "BAJA CALIFORNIA": edo = "BC"; break;
        case "BAJA CALIFORNIA SUR": edo = "BS"; break;
        case "CAMPECHE": edo = "CC"; break;
        case "COAHUILA DE ZARAGOZA": edo = "CL"; break;
        case "COLIMA": edo = "CM"; break;
        case "CHIAPAS": edo = "CS"; break;
        case "CHIHUAHUA": edo = "CH"; break;
        case "DISTRITO FEDERAL": edo = "DF"; break;
        case "DURANGO": edo = "DG"; break;
        case "GUANAJUATO": edo = "GT"; break;
        case "GUERRERO": edo = "GR"; break;
        case "HIDALGO": edo = "HG"; break;
        case "JALISCO": edo = "JC"; break;
        case "MÉXICO": edo = "MC"; break;
        case "MICHOACÁN DE OCAMPO": edo = "MN"; break;
        case "MORELOS": edo = "MS"; break;
        case "NAYARIT": edo = "NT"; break;
        case "NUEVO LEÓN": edo = "NL"; break;
        case "OAXACA": edo = "OC"; break;
        case "PUEBLA": edo = "PL"; break;
        case "QUERÉTARO": edo = "QT"; break;
        case "QUINTANA ROO": edo = "QR"; break;
        case "SAN LUIS POTOSÍ": edo = "SP"; break;
        case "SINALOA": edo = "SL"; break;
        case "SONORA": edo = "SR"; break;
        case "TABASCO": edo = "TC"; break;
        case "TAMAULIPAS": edo = "TS"; break;
        case "TLAXCALA": edo = "TL"; break;
        case "VERACRUZ DE IGNACIO DE LA LLAVE": edo = "VZ"; break;
        case "YUCATÁN": edo = "YN"; break;
        case "ZACATECAS": edo = "ZS"; break;
    }

    var s3 = materno[0];
    var s4 = nombre[0];

    var fecha = FechaNacimiento;
    var fechaSplit = fecha.split("/");

    var s5 = fechaSplit[2][2] + fechaSplit[2][3];
    var s6 = fechaSplit[1];
    var s7 = fechaSplit[0];

    var primeros10Caracteres = ''

    //primeros10Caracteres = calculaRFC('VICTOR HUGO', 'ORTEGON', 'IBARRA', '06/11/1986');
    primeros10Caracteres = calculaRFC(Nombre, ApellidoPaterno, ApellidoMaterno, FechaNacimiento);


    return primeros10Caracteres + sexo + edo + s8 + s9 + s10;
} 

function calculaRFC(Nombre, ApellidoPaterno, ApellidoMaterno, FechaNacimiento) {
    function quitaArticulos(palabra) {
        return palabra.replace("DEL ", "").replace("LAS ", "").replace("DE ",
				"").replace("LA ", "").replace("Y ", "").replace("A ", "");
    }
    function esVocal(letra) {
        if (letra == 'A' || letra == 'E' || letra == 'I' || letra == 'O'
				|| letra == 'U' || letra == 'a' || letra == 'e' || letra == 'i'
				|| letra == 'o' || letra == 'u')
            return true;
        else
            return false;
    }

    nombre = Nombre.toUpperCase();

    apellidoPaterno = ApellidoPaterno.toUpperCase();

    apellidoMaterno = ApellidoMaterno.toUpperCase();

    fecha = FechaNacimiento;

    var rfc = "";

    apellidoPaterno = quitaArticulos(apellidoPaterno);
    apellidoMaterno = quitaArticulos(apellidoMaterno);

    rfc += apellidoPaterno.substr(0, 1);

    var l = apellidoPaterno.length;
    var c;
    for (i = 0; i < l; i++) {

        if (i > 0) {
            c = apellidoPaterno.charAt(i);
            if (esVocal(c)) {
                rfc += c;
                break;
            }
        }
    }

    rfc += apellidoMaterno.substr(0, 1);

    rfc += nombre.substr(0, 1);

    rfc = SustituyePalabrasInconvenientes(rfc);

    rfc += fecha.substr(8, 10);

    rfc += fecha.substr(3, 5).substr(0, 2);

    rfc += fecha.substr(0, 2);

    // rfc += "-" + homclave;

    return rfc;

}


function SustituyePalabrasInconvenientes(frase) {
    var palabrasInconvenientes = []
    var palabra = {}

    palabra.palabraInconveniente = 'BACA'; palabra.palabraSustituida = 'BXCA'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'BAKA'; palabra.palabraSustituida = 'BXKA'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'BUEI'; palabra.palabraSustituida = 'BXEI'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'BUEY'; palabra.palabraSustituida = 'BXEY'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'CACA'; palabra.palabraSustituida = 'CXCA'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'CACO'; palabra.palabraSustituida = 'CXCO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'CAGA'; palabra.palabraSustituida = 'CXGA'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'CAGO'; palabra.palabraSustituida = 'CXGO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'CAKA'; palabra.palabraSustituida = 'CXKA'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'CAKO'; palabra.palabraSustituida = 'CXKO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'COGE'; palabra.palabraSustituida = 'CXGE'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'COGI'; palabra.palabraSustituida = 'CXGI'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'COJA'; palabra.palabraSustituida = 'CXJA'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'COJE'; palabra.palabraSustituida = 'CXJE'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'COJI'; palabra.palabraSustituida = 'CXJI'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'COJO'; palabra.palabraSustituida = 'CXJO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'COLA'; palabra.palabraSustituida = 'CXLA'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'CULO'; palabra.palabraSustituida = 'CXLO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'FALO'; palabra.palabraSustituida = 'FXLO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'FETO'; palabra.palabraSustituida = 'FXTO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'GETA'; palabra.palabraSustituida = 'GXTA'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'GUEI'; palabra.palabraSustituida = 'GXEI'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'GUEY'; palabra.palabraSustituida = 'GXEY'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'JETA'; palabra.palabraSustituida = 'JXTA'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'JOTO'; palabra.palabraSustituida = 'JXTO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'KACA'; palabra.palabraSustituida = 'KXCA'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'KACO'; palabra.palabraSustituida = 'KXCO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'KAGA'; palabra.palabraSustituida = 'KXGA'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'KAGO'; palabra.palabraSustituida = 'KXGO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'KAKA'; palabra.palabraSustituida = 'KXKA'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'KAKO'; palabra.palabraSustituida = 'KXKO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'KOGE'; palabra.palabraSustituida = 'KXGE'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'KOGI'; palabra.palabraSustituida = 'KXGI'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'KOJA'; palabra.palabraSustituida = 'KXJA'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'KOJE'; palabra.palabraSustituida = 'KXJE'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'KOJI'; palabra.palabraSustituida = 'KXJI'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'KOJO'; palabra.palabraSustituida = 'KXJO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'KOLA'; palabra.palabraSustituida = 'KXLA'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'KULO'; palabra.palabraSustituida = 'KXLO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'LILO'; palabra.palabraSustituida = 'LXLO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'LOCA'; palabra.palabraSustituida = 'LXCA'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'LOCO'; palabra.palabraSustituida = 'LXCO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'LOKA'; palabra.palabraSustituida = 'LXKA'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'LOKO'; palabra.palabraSustituida = 'LXKO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'MAME'; palabra.palabraSustituida = 'MXME'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'MAMO'; palabra.palabraSustituida = 'MXMO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'MEAR'; palabra.palabraSustituida = 'MXAR'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'MEAS'; palabra.palabraSustituida = 'MXAS'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'MEON'; palabra.palabraSustituida = 'MXON'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'MIAR'; palabra.palabraSustituida = 'MXAR'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'MION'; palabra.palabraSustituida = 'MXON'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'MOCO'; palabra.palabraSustituida = 'MXCO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'MOKO'; palabra.palabraSustituida = 'MXKO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'MULA'; palabra.palabraSustituida = 'MXLA'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'MULO'; palabra.palabraSustituida = 'MXLO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'NACA'; palabra.palabraSustituida = 'NXCA'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'NACO'; palabra.palabraSustituida = 'NXCO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'PEDA'; palabra.palabraSustituida = 'PXDA'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'PEDO'; palabra.palabraSustituida = 'PXDO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'PENE'; palabra.palabraSustituida = 'PXNE'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'PIPI'; palabra.palabraSustituida = 'PXPI'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'PITO'; palabra.palabraSustituida = 'PXTO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'POPO'; palabra.palabraSustituida = 'PXPO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'PUTA'; palabra.palabraSustituida = 'PXTA'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'PUTO'; palabra.palabraSustituida = 'PXTO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'QULO'; palabra.palabraSustituida = 'QXLO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'RATA'; palabra.palabraSustituida = 'RXTA'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'ROBA'; palabra.palabraSustituida = 'RXBA'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'ROBE'; palabra.palabraSustituida = 'RXBE'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'ROBO'; palabra.palabraSustituida = 'RXBO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'RUIN'; palabra.palabraSustituida = 'RXIN'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'SENO'; palabra.palabraSustituida = 'SXNO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'TETA'; palabra.palabraSustituida = 'TXTA'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'VACA'; palabra.palabraSustituida = 'VXCA'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'VAGA'; palabra.palabraSustituida = 'VXGA'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'VAGO'; palabra.palabraSustituida = 'VXGO'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'VAKA'; palabra.palabraSustituida = 'VXKA'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'VUEI'; palabra.palabraSustituida = 'VXEI'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'VUEY'; palabra.palabraSustituida = 'VXEY'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'WUEI'; palabra.palabraSustituida = 'WXEI'; palabrasInconvenientes.push($.extend({}, palabra));
    palabra.palabraInconveniente = 'WUEY'; palabra.palabraSustituida = 'WXEY'; palabrasInconvenientes.push($.extend({}, palabra));

    for (var i = 0; i < palabrasInconvenientes.length; i++) {
        if (palabrasInconvenientes[i].palabraInconveniente == frase) {
            frase = palabrasInconvenientes[i].palabraSustituida;
        }
    }

    return frase;
}
 