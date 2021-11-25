import programas.*

class Computadora {
	var memoriaTotal   /* va como var como el disco total ya que suele ser expandible */
	var discoTotal
	var property sistemaOperativo 
	var property vulnerable = false
	
	const property programasInstalados = []
	const property programasEnEjecucion = []
	
	method discoDisponible() = discoTotal - self.discoUsado()
	method memoriaDisponible() = memoriaTotal - self.memoriaUsada()
	method discoUsado() = programasInstalados.sum{programa=> programa.discoUsado()} + sistemaOperativo.discoUsado()
	method memoriaUsada() = programasEnEjecucion.sum{programa=> programa.memoriaUsada()}
	method memoriaSuficiente(programa) = self.memoriaDisponible() >= programa.memoriaUsada() 
	method discoSuficiente(programa) = self.discoDisponible() >= programa.discoUsado()
	
	method enCondicionesSO() = programasEnEjecucion.contains(sistemaOperativo)
	method estaInstalado(programa) = programasInstalados.contains(programa) or programa == sistemaOperativo
	
	method detenerTodosLosProgramas() {
		programasEnEjecucion.forEach{programa => self.detener(programa)}
	}	
	
	method instalar(programa){
		self.validarInstalacion(programa)
		programa.instalarseEn(self)
	}
	
	method agregar(programa){
		programasInstalados.add(programa)
	}
		
	method validarInstalacion(programa){
		if (!self.discoSuficiente(programa)) throw new Exception(message="No se puede instalar el programa")
	}

	method ejecutar(programa) {
		self.validarEjecucion(programa)
		programa.ejecutarseEn(self)
	}

	method validarEjecucion(programa){
		if (!programa.puedeEjecutarseEn(self) and self.memoriaSuficiente(programa)) throw new Exception(message="No se puede ejecutar el programa")
	}
	
	method abrir(programa){
		programasEnEjecucion.add(programa)
	}
	
	method detener(programa){
		programa.detenerseEn(self)
	}
	method cerrar(programa)	{
		programasEnEjecucion.remove(programa)
	}
	
	method programaQueMasMemoriaUsa() = programasEnEjecucion.max{programa=>programa.memoriaUsada()}
	
	method programaMuyPesado() = programasInstalados.any{programa=> programa.discoUsado() >= discoTotal/2}
	
	method virusDeMasImpacto(muchosVirus) =
		muchosVirus.sortedBy{v1, v2 => v1.cantidadInfectados() > v2.cantidadInfectados()}.take(3)
	
	method desinstalar(programa) {
		// La consigna no lo detalla, se asume que implica primero detener el programa y luego quitarlo del disco. 
		self.detener(programa)  
		programasInstalados.remove(programa)
	}
	
	method programasQueAtaca(virus) = programasInstalados.filter{programa=>virus.puedeAtacar(programa)}
	
	method desinstalarPrimerPrograma() {
		self.desinstalar(programasInstalados.first())
	}
	method ataqueIventado(malicioso) {
		// Algo no trivial
	}
		
	method limpiarCon(antivirus){
		programasInstalados.forEach{programa=> programa.limpiarCon(antivirus,self)}
		self.resolverVulnerabilidad()
	}

	method hacerVulnerable() {
		vulnerable = true
	}
	method resolverVulnerabilidad() {
		vulnerable = false
	}

}