stop();

////////Importación de paquetes para generar efectos////////
import gs.*;
import gs.easing.*;
import gs.plugins.*;
TweenPlugin.activate([ColorTransformPlugin, TintPlugin]);
//////**Importación de paquetes para generar efectos**//////

////////Definición de variables////////
var tablero:Array;
var baldozas:Array;
var eventoTeclado:Object = new Object();
var dx:Number;
var dy:Number;
var siguientePaso:Boolean;
var pasosSiguientes:Array
var efectoMovimientoP:TweenMax; //Efectos para el personaje
var efectoMovimientoT:TweenMax; //Efectos para el tablero
var efectoMovimientoF:TweenMax; //Efectos para el fondo
var duracionMovimiento:Number = 0.3;
var personaje:MovieClip;
var muerePersonaje:Boolean = true;
var numObstaculos:Number = 4;
var obstaculosPasados:Array = new Array(false,false,false,false);
var retroAbierta:Boolean = false;
var respuestas:Array = new Array(1,1,3,2);
var cronometro:Number = 0;
var segundos:Number = 0;
var tiempoJuego:Number = 80;


var sonidoPaso:Sound;
var sonidoCaida:Sound;
var sonidoObstaculos:Sound;

var orixPersonaje;
var oriyPersonaje;
var irePersonaje;

//////**Definición de variables**//////


iniciar();


function iniciar(){
	tablero = new Array();
	definirTablero();
	baldozas = new Array(tablero.length);
	pasosSiguientes = new Array();
	muerePersonaje = false;
	breiniciar.enabled = false;
	breiniciar._visible = false;
	segundos = tiempoJuego;
	c_temporizador.texto.text = "00:"+segundos;
	breiniciar.onRelease = function(){
		reiniciarActividad();
	}
	
	
	crearTablero();
	crearPersonaje();
	centrarTodo();
	datosAdicionales();
}
function definirTablero(){
	tablero[0] = 	[0,0,3,0,0,0,0];
	tablero[1] = 	[0,1,2,1,1,1,0];
	tablero[2] = 	[1,1,0,1,0,1,1];
	tablero[3] = 	[0,0,0,1,0,0,1];
	tablero[4] = 	[0,1,0,2,0,1,1];
	tablero[5] = 	[0,1,0,1,0,1,0];
	tablero[6] = 	[1,1,1,1,1,1,0];
	tablero[7] = 	[0,0,1,0,1,0,0];
	tablero[8] = 	[1,0,2,1,1,0,0];
	tablero[9] = 	[1,1,1,0,0,0,0];
	tablero[10] = 	[0,0,1,1,0,1,0];
	tablero[11] = 	[1,0,0,1,0,1,1];
	tablero[12] = 	[1,1,0,2,1,1,0];
	tablero[13] = 	[1,0,0,1,0,1,0];
	tablero[14] = 	[1,0,1,1,0,1,0];
	tablero[15] = 	[1,0,1,0,0,1,0];
	tablero[16] = 	[1,0,1,0,0,1,0];
	tablero[17] = 	[1,1,1,1,1,1,1];
}
function crearTablero(){
	var posx:Number = 0;
	var posy:Number = 0;
	var profundidades:Number = tablero.length * tablero[0].length;
	var contadorObstaculos:Number = numObstaculos;
	for(var i=0;i<tablero.length;i++){
		var fila:String = "";
		
		var profundidad:Number = profundidades - ( (tablero.length - (i+1)) * tablero[i].length);
		//var profundidad:Number = tablero[i].length + (i);
		
		var orix:Number = posx;
		var oriy:Number = posy;
		var sueloCreado:MovieClip;
		//var areaSueloCreado:MovieClip;
		
		baldozas[i] = new Array(tablero[i].length);
		
		//for(var j=tablero[i].length-1;j>=0;j--){
		for(var j=0;j<tablero[i].length;j++){
			//fila+=","+tablero[i][j];
			switch(tablero[i][j]){
				case 0:
					//areaSueloCreado = Ctablero.attachMovie("areaSuelo","a_vacio"+(i+1)+""+(j+1),(profundidad * 100));
					sueloCreado = Ctablero.attachMovie("suelo","vacio"+(i+1)+""+(j+1),profundidad);
					sueloCreado._alpha = 0;
					break;
				case 1:
					//areaSueloCreado = Ctablero.attachMovie("areaSuelo","a_suelo"+(i+1)+""+(j+1), (profundidad * 100));
					sueloCreado = Ctablero.attachMovie("suelo","suelo"+(i+1)+""+(j+1),profundidad);
					break;
				case 2:
					sueloCreado = Ctablero.attachMovie("suelo","obstaculo"+(i+1)+""+(j+1),profundidad);
					sueloCreado.obstaculo = contadorObstaculos;
					if(!obstaculosPasados[contadorObstaculos-1])
						Ctablero["obstaculo"+(i+1)+""+(j+1)].attachMovie("obstaculo","detalle",Ctablero["obstaculo"+(i+1)+""+(j+1)].getNextHighestDepth());
					contadorObstaculos--;
					break;
				case 3:
					//areaSueloCreado = Ctablero.attachMovie("areaSuelo","a_meta",(profundidad * 100));				
					sueloCreado = Ctablero.attachMovie("suelo","meta",profundidad);
					sueloCreado.attachMovie("meta","meta",sueloCreado.getNextHighestDepth());
					break;
				
			}
			//areaSueloCreado._alpha = 100;
			//baldozas[i][j] = areaSueloCreado;
			
			baldozas[i][j] = sueloCreado;
			
			//areaSueloCreado._x = posx;
			//areaSueloCreado._y = posy;
			sueloCreado._x = posx;
			sueloCreado._y = posy;
			
			posx = sueloCreado._x + (sueloCreado._width / 2) + 5.6;
			posy = sueloCreado._y - (sueloCreado._height / 2) + 6.85;
			
			//posx = areaSueloCreado._x + (areaSueloCreado._width / 2) + 5.6;
			//posy = areaSueloCreado._y - (areaSueloCreado._height / 2) + 6.85;
			
			profundidad--;
		}
		//trace(fila);
		
		//posx = orix + (areaSueloCreado._width / 2);
		//posy = oriy + (areaSueloCreado._height / 2) + 8.25;
		
		
		posx = orix + (sueloCreado._width / 2);
		posy = oriy + (sueloCreado._height / 2) + 8.25;
		
		//profundidad++;
	}
}
function crearPersonaje(){
	//Seleccionar la casilla donde aparecerá el personaje
	var personajex:Number;
	var personajey:Number;
	var filaBaldoza:Number;
	var columnaBaldoza:Number;
	var listopos:Boolean = false;
	while(!listopos){
		var pos:Number = numeroAleatorio(0,tablero[0].length);
		if(tablero[tablero.length - 1][pos - 1] == 1){
			personajex = baldozas[tablero.length - 1][pos - 1]._x;
			personajey = baldozas[tablero.length - 1][pos - 1]._y;
			
			filaBaldoza = tablero.length - 1;
			columnaBaldoza = pos - 1;
			
			listopos=true;
		}
	}
	//Ctablero.attachMovie("areaPersonaje","a_personaje",Ctablero.getNextHighestDepth());	
	Cpersonaje.attachMovie("personaje","personaje",Ctablero.getNextHighestDepth());
	personaje = Cpersonaje;

	personaje._x = Ctablero._x + personajex;
	personaje._y = Ctablero._y + personajey;
	personaje._alpha = 100;	
	personaje.fBaldoza = filaBaldoza;
	personaje.cBaldoza = columnaBaldoza;
	personaje.dirAnterior = "";
	
	if(orixPersonaje != undefined && oriyPersonaje != undefined){
		trace("aaaa");
		//pasosSiguientes.push([orixPersonaje,oriyPersonaje,direPersonaje]);
		//moverPersonaje();
		
		personaje._x = Ctablero._x + baldozas[orixPersonaje][oriyPersonaje]._x;
		personaje._y = Ctablero._y + baldozas[orixPersonaje][oriyPersonaje]._y;
		personaje.fBaldoza = orixPersonaje;
		personaje.cBaldoza = oriyPersonaje;
		personaje.dirAnterior = direPersonaje;
	}
}
function calcularSiguientePaso(){
	var operadorF:Number = 0;
	var operadorC:Number = 0;
	var direccionNueva:String = "";
	
	//Obtener la dirección de movimiento del personaje
	switch(Key.getCode()){
		//Izquierda
		case 37:
			Cpersonaje.personaje.gotoAndPlay("izq");			
			operadorC = -1;
			break;
		//Arriba
		case 38:
			Cpersonaje.personaje.gotoAndPlay("arr");
			operadorF = -1;
			break;
		//Derecha
		case 39:			
			Cpersonaje.personaje.gotoAndPlay("der");
			operadorC = +1;
			break;
		//Abajo
		case 40:
			Cpersonaje.personaje.gotoAndPlay("aba");
			operadorF = 1;
			break;
		default:
			Key.addListener(eventoTeclado);
			break;
	}
	if(operadorC != 0 && operadorF == 0)
		direccionNueva = "h";
	else if(operadorC == 0 && operadorF != 0)
		direccionNueva = "v";
	
	
	
	if(personaje.dirAnterior == "")
		personaje.dirAnterior = direccionNueva;
	
	var fDestino:Number = personaje.fBaldoza + operadorF;
	var cDestino:Number = personaje.cBaldoza + operadorC;
	
	if(fDestino >= 0 && cDestino >= 0 && fDestino < tablero.length && cDestino < tablero[0].length){//Se puede mover
		pasosSiguientes.push([fDestino,cDestino,direccionNueva]);
		//trace(pasosSiguientes);
		if(efectoMovimientoP == undefined || efectoMovimientoP == null){
			
			sonidoPaso.stop();
			sonidoPaso = null;
			sonidoPaso = new Sound();
			sonidoPaso.attachSound("spaso",true);
			sonidoPaso.start();
			sonidoPaso.onSoundComplete = function(){
				sonidoPaso.stop();
				sonidoPaso = null;
			}
			
			
			moverPersonaje();
		}
	}
	else
		Key.addListener(eventoTeclado);
}
function moverPersonaje(){
	var coordenadas = pasosSiguientes.shift();
	if(coordenadas != undefined){		
		var fDestino:Number = coordenadas[0];
		var cDestino:Number = coordenadas[1];
		var direccionNueva:String = coordenadas[2];
		
		//dx = Ctablero._x + baldozas[fDestino][cDestino]._x;//La posición de la baldoza con respecto al personaje (_root)
		//dy = Ctablero._y + baldozas[fDestino][cDestino]._y;//La posición de la baldoza con respecto al personaje (_root)
		
		if(tablero[fDestino][cDestino] == 0)
			muerePersonaje = true;
		if(tablero[fDestino][cDestino] == 2){
			if(!obstaculosPasados[baldozas[fDestino][cDestino].obstaculo-1]){
				sonidoObstaculo.stop();
				sonidoObstaculo = null;
				sonidoObstaculo = new Sound();
				sonidoObstaculo.attachSound("sobstaculo",true);
				sonidoObstaculo.start();
				sonidoObstaculo.onSoundComplete = function(){
					sonidoObstaculo.stop();
					sonidoObstaculo = null;
				}			
				
				direPersonaje = direccionNueva;
				
				mostrarRetro(baldozas[fDestino][cDestino].obstaculo); 
			}
		}
		if(tablero[fDestino][cDestino] == 3)
			llegadaMeta();
		dx = Ctablero._x + (personaje._x - (Ctablero._x + baldozas[fDestino][cDestino]._x));
		dy = Ctablero._y + (personaje._y - (Ctablero._y + baldozas[fDestino][cDestino]._y));
		
		personaje.fBaldoza = fDestino;
		personaje.cBaldoza = cDestino;
		
		if(efectoMovimientoP != undefined){
			efectoMovimientoP.pause();
			efectoMovimientoP = null;
		}
		
		//efectoMovimientoP = new TweenMax(personaje,duracionMovimiento,{_x:dx,_y:dy,onComplete:moverPersonaje});
		efectoMovimientoP = new TweenMax(Ctablero,duracionMovimiento,{_x:dx,_y:dy,onComplete:moverPersonaje});
				
		var distanciaX:Number = fondo._x + (personaje._x - (Ctablero._x + baldozas[fDestino][cDestino]._x));
		var distanciaY:Number = fondo._y + (personaje._y - (Ctablero._y + baldozas[fDestino][cDestino]._y));
		
		efectoMovimientoF = new TweenMax(fondo,duracionMovimiento,{_x:distanciaX,_y:distanciaY});
	}
	else{
		personaje.dirAnterior = "";
		efectoMovimientoP = null;
	}
	
	if(muerePersonaje){
		Key.removeListener(eventoTeclado);
		TweenMax.to(personaje,2,{_y:personaje._y+1000,delay:0.2,_alpha:0,onComplete:muertePersonaje,onStart:cambiazo,ease:Sine.easeOut});
	}
	else{
		if(!retroAbierta)
			Key.addListener(eventoTeclado);
	}
}
function cambiazo(){
	
	sonidoCaida.stop();
	sonidoCaida = null;
	sonidoCaida = new Sound();
	sonidoCaida.attachSound("scaida",true);
	sonidoCaida.start();
	sonidoCaida.onSoundComplete = function(){
		sonidoCaida.stop();
		sonidoCaida = null;
	}
	
	
	efectoMovimientoP.pause();
	efectoMovimientoP = null;
	personaje.swapDepths(Ctablero);
	personaje.alfondo = true;
}
function centrarTodo(){

	personaje.orix = personaje._x;
	personaje.oriy = personaje._y;
	
	Ctablero.orix = Ctablero._x;
	Ctablero.oriy = Ctablero._y;
	
	fondo.orix = fondo._x;
	fondo.oriy = fondo._y;

	//Mover el personaje al centro de la pantalla (Al centro de Mjuego)
	
	var distanciaX:Number = (escenario._x + escenario._width/2) - (personaje._x - Ctablero._x);
	var distanciaY:Number = (escenario._y + escenario._height/2) - (personaje._y - Ctablero._y);
	
	TweenMax.to(personaje,4,{_x:(escenario._x + escenario._width/2),_y:(escenario._y + escenario._height/2),delay:1});
	TweenMax.to(Ctablero,4,{_x:distanciaX,_y:distanciaY,delay:1,onComplete:function(){iniciarActividad();}});
}
function numeroAleatorio(min:Number, max:Number):Number {
    var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min;
    return randomNum;
}
function mostrarRetro(numero:Number){
	retroAbierta = true;
	Key.removeListener(eventoTeclado);
	
	for(var i = 1;i<=numObstaculos;i++){
		if(i == numero)
			TweenMax.to(_root["r"+i],0.5,{_alpha:100,enabled:true,_visible:true,_x:_root["r"+i].orix,_y:_root["r"+i].oriy,ease:Sine.easeOut});
		else
			TweenMax.to(_root["r"+i],0.5,{_alpha:0,enabled:false,_visible:false,_x:_root["r"+i].desx,_y:_root["r"+i].desy,ease:Sine.easeOut});
	}
}
function cerrarRetro(numero:Number){
	responder(_root["r"+numero].miRespuesta,numero);
	_root["r"+numero].gotoAndStop(0);
	retroAbierta = false;
	Key.addListener(eventoTeclado);
	TweenMax.to(_root["r"+numero],0.5,{_alpha:0,enabled:false,_visible:false,_x:_root["r"+i].desx,_y:_root["r"+i].desy,ease:Sine.easeOut});
}
function datosAdicionales(){
	for(var i = 1;i<=numObstaculos;i++){
		if(!obstaculosPasados[i-1]){
			_root["r"+i].numero = i;
			_root["r"+i].enabled = false;
			_root["r"+i]._visible = false;
			_root["r"+i].areaBCerrar.onRelease = _root["r"+i].boton_enviar.onRelease = function(){
				_root.cerrarRetro(this._parent.numero);
			}
		}
	}
}
function responder(respuesta:Number,pregunta:Number){
	if(respuestas[pregunta-1] == respuesta){
		obstaculosPasados[pregunta-1] = true;
		baldozas[personaje.fBaldoza][personaje.cBaldoza].detalle.removeMovieClip();
		
		orixPersonaje = personaje.fBaldoza;
		oriyPersonaje = personaje.cBaldoza;
		
		//obstaculosPasados++;
	}
	else{//Se cae el personaje con la baldoza
		Key.removeListener(eventoTeclado);
		habilitarBotonReiniciar();
		
		
		sonidoCaida.stop();
		sonidoCaida = null;
		sonidoCaida = new Sound();
		sonidoCaida.attachSound("scaida",true);
		sonidoCaida.start();
		sonidoCaida.onSoundComplete = function(){
			sonidoCaida.stop();
			sonidoCaida = null;
		}
		
		
		TweenMax.to(personaje,2,{_y:personaje._y+1000,delay:0.2,_alpha:0,onComplete:muertePersonaje,ease:Sine.easeOut});
		TweenMax.to(baldozas[personaje.fBaldoza][personaje.cBaldoza],2,{_y:baldozas[personaje.fBaldoza][personaje.cBaldoza]._y+1000,delay:0.2,_alpha:0,ease:Sine.easeOut});
	}		
}
function llegadaMeta(){
	var pasados:Number = 0;
	for(var i=0;i<obstaculosPasados.length-1;i++)
		if(obstaculosPasados)
			pasados++;
	if(pasados == numObstaculos){
		Key.removeListener(eventoTeclado);
		gotoAndPlay("finalizarActividad");
	}
}
function muertePersonaje(){
	Key.removeListener(eventoTeclado);
	clearInterval(cronometro);
	TweenMax.to(breiniciar,0.5,{_alpha:100,enabled:true,_visible:true,ease:Sine.easeOut});	
	
	//TweenMax.to(personaje,2,{_x:personaje.orix,_y:personaje.oriy});
	//TweenMax.to(Ctablero,2,{_x:Ctablero.orix,_y:Ctablero.oriy});
}
function reiniciarActividad(){
	
	personaje._x = personaje.orix;
	personaje._y = personaje.oriy;
	
	Ctablero._x = Ctablero.orix;
	Ctablero._y = Ctablero.oriy;
	
	fondo._x = fondo.orix;
	fondo._y = fondo.oriy;
	
	TweenMax.to(breiniciar,0.5,{_alpha:0,enabled:false,_visible:false,ease:Sine.easeOut});
	for(var i=0;i<tablero.length;i++){
		for(var j=0;j<tablero[i].length;j++){
			baldozas[i][j].removeMovieClip();
		}
	}
	baldozas = null;
	tablero = null;
	
	//personaje._y -=  1000;
	//personaje._alpha = 100;
	if(personaje.alfondo){
		personaje.alfondo = false;
		personaje.swapDepths(Ctablero);
	}
	Cpersonaje.personaje.removeMovieClip();
	personaje = null;
	iniciar();
}
function tiempo(){
	segundos--;
	if(segundos < 10){
		c_temporizador.texto.textColor = 0xFF0000;
		c_temporizador.texto.text = "00:0"+segundos;
	}
	else
		c_temporizador.texto.text = "00:"+segundos;
	if(segundos == 0){
		clearInterval(cronometro);
		muertePersonaje();
	}
}
function iniciarActividad(){
	Key.addListener(eventoTeclado);
	cronometro = setInterval(tiempo,1000);
}


////////Definición de eventos////////
eventoTeclado.onKeyDown = function(){
	Key.removeListener(eventoTeclado);
	calcularSiguientePaso();
};
//////**Definición de eventos**//////