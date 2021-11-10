
// Parcial danger zone -- Franco D'Alessio


class Empleados{
	const habilidades = []
	var property salud 
	var property puesto
	
	method quedaIncapacitado() = salud < puesto.saludCritica()
	
	method puedeUsar(habilidad) = not self.quedaIncapacitado() and self.poseeHabilidad(habilidad)
	
	method poseeHabilidad(habilidad) = habilidades.contains(habilidad)
	
	method recibirDanio(peligrosidad) { salud -= peligrosidad} 
	
	method finalizarMision(mision) { return
		
		if(self.sobreviveALaMision()){
			
			self.completarMision(mision)
			
		}
		else{}
		
	}
	
	method sobreviveALaMision() = salud > 0
	method entender(habilidad) = habilidades.add(habilidad)
	method completarMision(mision) = puesto.completarMision(mision,self)
}


class Jefes inherits Empleados{
	var subordinados
	
	override method poseeHabilidad(habilidad) = super(habilidad) or self.algunSubordinadoPuedeUsarLa(habilidad)
	
	method algunSubordinadoPuedeUsarLa(habilidad) = subordinados.any{subordinado => subordinado.puedeUsar(habilidad)}
}


class Mision {
	const habilidadesRequeridas = []
	const peligrosidad
	method puedeRealizarMision(persona){
		if(not habilidadesRequeridas.all{habilidad=>persona.puedeUsar(habilidad)}){
			
			throw new DomainException (message = " No se puede hacer la mision")
		}
		persona.recibirDanio(peligrosidad)
		persona.finalizarMision(self)
	}
	method aprenderHabilidad(persona) = self.habilidadesQueNoTiene(persona).forEach{habilidad=>persona.entender(habilidad)}
	method habilidadesQueNoTiene(persona) = habilidadesRequeridas.filter{habilidad=> not persona.poseeHabilidad(habilidad)}
}


object espia{
	method saludCritica() = 15
	
	method completarMision(mision,persona){
		
		mision.aprenderHabilidad(persona)
	}
}

class Oficinistas{
	var cantidadEstrellas
	method saludCritica() = 40-5*cantidadEstrellas
	
	
	method completarMision(mision,persona){
		cantidadEstrellas+=1
		
		if(cantidadEstrellas==3){
			
			persona.puesto(espia)
			
		}
	}
}


class Equipo{
	var property empleados = []
	
	method puedeUsar(habilidad) = empleados.any{empleado => empleado.puedeUsar(habilidad)}
	method recibirDanio(cantidad) = empleados.forEach{empleado => empleado.recibirDanio(cantidad/3)} 
	method finalizarMision(mision) = empleados.forEach{empleado => empleado.finalizarMision(mision)}
}

