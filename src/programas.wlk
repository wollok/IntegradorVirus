class Programa {
	const disco
	const memoria
	const property hospedados = []
		
	var property ejecuciones = 0
	
	method discoUsado() = disco + hospedados.sum{hospedado => hospedado.discoUsado()}
	method memoriaUsada() = memoria
	
	method hospedar(malicioso) {
		hospedados.add(malicioso)
	}
	
	method infectar(virus){
		if (!hospedados.contains(virus)){
			virus.registrarInfeccion()
			self.hospedar(virus)
		}
	}
	
	method ejecutarseEn(computadora){
		ejecuciones += 1
		computadora.abrir(self)
		hospedados.forEach{hospedado => hospedado.ejecutarseEn(computadora)}
	}
	
	method instalarseEn(computadora){
		computadora.agregar(self)
	}
	
	method detenerseEn(computadora){
		computadora.cerrar(self)
	}
	
	method puedeInstalarseEn(computadoras) = computadoras.filter{computadora => computadora.puedeInstalarse(self)}
	
	method esSano() = hospedados.isEmpty()
	
	method limpiarCon(antivirus, computadora){
		hospedados.forEach{hospedado => 
			if (antivirus.elimina(hospedado)){
				hospedados.remove(hospedado)
				computadora.detener(hospedado)
			} 
		}
	}
	method puedeEjecutarseEn(computadora) = computadora.estaInstalado(self) && computadora.enCondicionesSO() 
	
}

class SistemaOperativo inherits Programa {

	override method instalarseEn(computadora){
		computadora.sistemaOperativo(self)
	}
	
	override method detenerseEn(computadora){
		super(computadora) 
		computadora.detenerTodosLosProgramas()
	}
	override method puedeEjecutarseEn(computadora) = 
		computadora.sistemaOperativo() == self
	
}

class ProgramaMalicioso inherits Programa {
	method puedeEliminarlo(antivirus) = antivirus.virusQueMata().contains(self) 
}

class Troyano inherits ProgramaMalicioso {
	override method ejecutarseEn(computadora){
		super(computadora)
		computadora.hacerVulnerable()
	}
}

class Virus inherits ProgramaMalicioso {
	var property potencia
	var property descripcion
	var property cantidadInfectados = 0
	
	method registrarInfeccion(){
		cantidadInfectados += 1
	}
	override method ejecutarseEn(computadora){
		super(computadora)
		computadora.programasQueAtaca(self).forEach{programa => programa.infectar(self)}
	}
	
	method puedeAtacar(programa) = programa.ejecuciones() > potencia
}

class Destructor inherits ProgramaMalicioso {	
	const cantidadMaximaEjecuciones = 3
	
	override method ejecutarseEn(computadora) {
		super(computadora)
		if(ejecuciones < cantidadMaximaEjecuciones)
			computadora.desinstalarPrimerPrograma()
	}
}

class Inventado inherits Destructor { /* Hace lo mismo que un Destructor pero además infecta otro programa al azar (se reproduce)*/
	override method ejecutarseEn(computadora) {
		super(computadora)
		computadora.ataqueIventado(self)
	}
}

class Antivirus inherits Programa {
	var virusQueElimina
	
	override method ejecutarseEn(computadora) {
		super(computadora)
		computadora.limpiarCon(self)
	}
	method elimina(virus) = virusQueElimina.contains(virus.descripcion())
}

