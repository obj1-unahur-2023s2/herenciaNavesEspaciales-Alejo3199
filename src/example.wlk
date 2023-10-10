class Nave {
	var velocidad = 0
	var direccion = 0
	var combustible = 0
	method velocidad() = velocidad
	method acelerar(cuanto){ 
		velocidad = 100000.min(velocidad + cuanto)	
	}
	method desacelerar(cuanto) {
		 velocidad= 0.max(velocidad - cuanto)
	}
	method direccion()= direccion
	method irHaciaElSol() { direccion = 10}
	method escaparDelSol() { direccion = -10}
	method ponerseParaleloAlSol() {direccion = 0}
	method acercarseUnPocoAlSol() {direccion = 10.min(direccion + 1)}
	method alejarseUnPocoDelSol() {direccion = -10.max(direccion - 1)}
	method prepararViaje() {
		self.cargarCombustible(30000)
		self.acelerar(5000)
	}
	
	method combustible() = combustible
	method cargarCombustible(cantidadACargar) = combustible + cantidadACargar
	method descargarCombustible(cantidadADescargar) = 0.max(combustible - cantidadADescargar)
	
	method estaTranquila() = combustible >= 4000 and self.velocidad() < 12000
	
	method recibirAmenaza() {
		self.escapar()
		self.avisar()
	}
	method escapar()
	method avisar()
	
	method relajo() = self.estaTranquila() and self.tienePocaActividad()
	method tienePocaActividad()
		

	 
}
class Baliza inherits Nave {
	var color
	var cambioColorBaliza = false  // se modifico para saber sio cambio el color alguna vez para el metodo tiene poca actividad
	method color() = color
	method cambiarColor(nuevoColor) {
		color = nuevoColor
		cambioColorBaliza = true
	}
	override method prepararViaje() {
		color = "verde"
		super()                         // cuando se utilizan super en todos estos preparar viajwe y no ser una connsulta sino una orden, tal vez es mejor poner un metodo abstracto q sea "method accion adicional" en la clase "Nave" y agregarlo en el "method prepararviaje"
		self.ponerseParaleloAlSol()	
	}
	override method estaTranquila() { 
		return super() and color != "Rojo"
	}
	override method escapar() {
		self.irHaciaElSol()
	}
	override method avisar()= self.color()
	override method tienePocaActividad() = not cambioColorBaliza
}

class Pasajero inherits Nave {
	var property pasajeros
	var  racionesDeComida
	var  racionesDeBebida 
	var descargadas = 0   // se modifico para saber vauntas descargar hubo para el metodo tiene poca actividad
	
	method cargarComida(cantidadACargar) {
		racionesDeComida += cantidadACargar
	}
	method cargarBebidas(cantidadACargar) {
		racionesDeBebida += cantidadACargar
	}
	method descargarComida(cantidadADescargar){
		racionesDeComida -= 0.max(cantidadADescargar)
		descargadas += cantidadADescargar
	}
	method descargarBebida(cantidadADescargar) {
		racionesDeBebida -= 0.max(cantidadADescargar)
		descargadas += cantidadADescargar
	}
	override method prepararViaje() {
		super()
		self.cargarComida(4 * pasajeros)
		self.cargarBebidas(6 * pasajeros)
		self.acercarseUnPocoAlSol()
		
	}
	override method escapar() {
		self.acelerar(velocidad * 2)
	}
	override method avisar() {
		self.descargarComida(pasajeros)
		self.descargarBebida(pasajeros * 2)
		}
	override method tienePocaActividad() = descargadas < 50
}

class Combate inherits Nave{
	var visible = true
	var misilesDesplegados= false
	const mensajes = []
	method ponerseVisible() {visible = true}
	method ponerseInvisible() {visible = false}
	method estaInvisible() = not visible
	method desplegarMisiles() {misilesDesplegados = true}
	method replegarMisiles() {misilesDesplegados = false}
	method misilesDesplegados() = misilesDesplegados
	method mensajes() = mensajes
	method emitirMensaje(mensaje) {mensajes.add(mensaje)}
	method mensajesEmitidos() = mensajes.size() 
	method primerMensajeEmitido(){
		if(mensajes.isEmpty())
			self.error("No hay mensajes")
			return mensajes.first()
	}
	method ultimoMensajeEmitido(){
		if(mensajes.isEmpty())
			self.error("No hay mensajes")
			return mensajes.last()
	}
	
	method esEscueta1() = mensajes.all({m => m.size() <= 30})     //dos maneras de hacer escueta
	method esEscueta2() = not mensajes.any({ m=> m.size() > 30})
	
	method emitioMensaje(mensaje) = mensajes.contains(mensaje)
	
	override method prepararViaje(){
		super()
		self.emitirMensaje("Saliendo en mision")
		self.ponerseVisible()
		self.replegarMisiles()
		self.acelerar(15000)
		
	}
	override method estaTranquila() {
		 return super() and not misilesDesplegados
		 }
	override method escapar() {
		self.acercarseUnPocoAlSol()
		self.acercarseUnPocoAlSol()
	}
	override method avisar(){
		self.emitirMensaje("Amenaza recibida")
	}
	override method tienePocaActividad() = self. esEscueta1()
}

class Hospital inherits Pasajero {
	var property quirofanoPreparado = true
	override method estaTranquila() {
		return super() and not quirofanoPreparado
	}
	override method recibirAmenaza() {
		super()
		quirofanoPreparado = true
	}
}

class Sigilosa inherits Combate {
	override method estaTranquila() {
		return super() and visible
	}
	override method recibirAmenaza() {
		super()
		self.desplegarMisiles()
		self.ponerseInvisible()
	}
}













































