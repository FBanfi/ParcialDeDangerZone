// PARCIAL DANGER ZONE

class Empleado {
	var habilidades = #{}
	var property salud = 100
	var property puesto = espia
	var misionesCompletadas
	
	method agregar(nuevasHabilidades) {
		habilidades.addAll(nuevasHabilidades)
	}
	method sufrirDano(dano) {
		salud = salud - dano
	}
	method estaIncapacitado() = puesto.saludCritica() > salud
	method puedeUsar(habilidad) = not self.estaIncapacitado() and self.posee(habilidad)
	method posee(habilidad) = habilidades.contains(habilidad)
	
	method cumplir(mision) {
		mision.serCumplidaPor(self)
	}
	method finalizar(mision) {
		if (salud > 0) {
			misionesCompletadas.add(mision)
			puesto.aplicarEfecto(mision, self)
		}
	}
	
}

class Jefe inherits Empleado {
	var subOrdinados = []
	
	override method posee(habilidad) = super(habilidad) or self.subOrdinadoPosee(habilidad)
	method subOrdinadoPosee(habilidad) = subOrdinados.any({subOrdinado => subOrdinado.puedeUsar(habilidad)})
}

object espia {
	
	method saludCritica() = 15
	method aplicarEfecto(mision, empleado) {
		empleado.agregar(mision.habilidadesRequeridas())
	}
}
class Oficinista {
	var estrellas
	
	method saludCritica() = 40 - 5 * estrellas
	method aplicarEfecto(mision, empleado) {
		estrellas += 1
		if (estrellas == 3) {
			empleado.puesto(espia)
		}
	}
}

class Mision {
	var property habilidadesRequeridas
	var peligrosidad
	
	method serCumplidaPor(asignado) {
		self.validarRequisitos(asignado)
		asignado.sufrirDano(peligrosidad)
		asignado.finalizar(self)
	}
	method validarRequisitos(asignado) {
		if (not self.reuneHabilidades(asignado)) {
			self.error("No puede realizar esta mision por que no tiene las habilidades necesarias")
		}
	}
	method reuneHabilidades(asignado) = habilidadesRequeridas.all({habilidad => asignado.puedeUsar(habilidad)})
}

class Equipo {
	var property empleados = []
	
	method puedeUsar(habilidad) {
		empleados.any({empleado => empleado.puedeUsar(habilidad)})
	}
	method sufrirDano(peligrosidad) {
		empleados.forEach({empleado => empleado.sufrirDano(peligrosidad/3)})
	}
	method finalizar(mision) {
		empleados.forEach({empleado => empleado.finalizar(mision)})
	}
	
}




