# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

#require_relative "sorpresa"
require_relative "titulo_propiedad"
require_relative "especulador"
require_relative "casilla"

module ModeloQytetet

  class Jugador
    
    attr_reader :nombre, :propiedades, :saldo
    attr_accessor :casillaActual,:encarcelado, :cartaLibertad
    

    def initialize(nombre, encarcelado = false, saldo = 7500, cartaLibertad = nil, casillaActual = nil, propiedades = Array.new)
      @encarcelado = encarcelado
      @nombre = nombre
      @saldo = saldo
      @cartaLibertad = cartaLibertad
      @casillaActual = casillaActual
      @propiedades = propiedades
    end
  
    def self.nuevo(nombre)
      new(nombre)
    end
    
    def self.copia(otroJugador)
      new(
        otroJugador.nombre, 
        otroJugador.encarcelado,
        otroJugador.saldo,
        otroJugador.cartaLibertad,
        otroJugador.casillaActual,
        otroJugador.propiedades
      )
    end
    private_class_method :new
  #methods
  
  def cancelarHipoteca(titulo)
    cancelar = false
      costeCancelar = titulo.calcularCosteCancelar
      tengoSaldo = tengoSaldo(costeCancelar)
      
      if tengoSaldo
        modificarSaldo(-costeCancelar)
        cancelar = titulo.cancelarHipoteca
      end
      
      cancelar
  end
  
  def comprarTituloPropiedad
    comprado = false
    costeCompra = @casillaActual.coste
    puts costeCompra
    if costeCompra < @saldo
      comprado = true
      @casillaActual.titulo.propietario = self
      @propiedades << @casillaActual.titulo
      self.modificarSaldo(-costeCompra)
    end

    comprado
  end
  
  def cuantasCasasHotelesTengo
    numCasHot = 0
    for i in 0...@propiedades.size
        numCasHot = numpropiedades + @propiedades[i].numCasas + @propiedades[i].numHoteles
      end
          
    numCasHot
    
  end
  
  def deboPagarAlquiler
    titulo = @casillaActual.titulo
    esDeMiPropiedad = esDeMiPropiedad(titulo)
    tienePropietario = false
    encarcelado = true
    estaHipotecada = true

    if (esDeMiPropiedad == false)
      tienePropietario = titulo.tengoPropietario
      if tienePropietario
        encarcelado = titulo.propietarioEncarcelado
        if !encarcelado
          estaHipotecada = titulo.hipotecada
        end
      end
    end
    debopagar = !esDeMiPropiedad && tienePropietario && !encarcelado && !estaHipotecada
    debopagar
  end
  
  def devolverCartaLibertad
    #prac3
    aux = @cartaLibertad
    @cartaLibertad = nil      
    return aux;
    
  end
  
  def edificarCasa(titulo)
    edificada = false
      
      numCasas = titulo.numCasas
      
      if puedoEdificarCasa(titulo)
        costeEdificarCasa = titulo.precioEdificar
        tengoSaldo = self.tengoSaldo(costeEdificarCasa)
        
        if(tengoSaldo)
          titulo.edificarCasa
          self.modificarSaldo(-costeEdificarCasa)
          edificada = true
        end
      end
      
      edificada
  end
  
  def  edificarHotel(titulo)
    edificado = false
      
    numHoteles = titulo.numHoteles
    #numCasas = titulo.numCasas

    if puedoEdificarHotel(titulo)
      costeEdificarHotel = titulo.precioEdificar
      tengoSaldo = self.tengoSaldo(costeEdificarHotel)

      if(tengoSaldo)
        titulo.edificarHotel
        self.modificarSaldo(-costeEdificarHotel)
        edificado = true
        titulo.numCasas = titulo.numCasas - 4
      end
    end

    edificado
  end
  
  def eliminarDeMisPropiedades(titulo)
    @propiedades.delete(titulo)
    titulo.propietario = nil
  end
  
  def esDeMiPropiedad( titulo)
    #prac3
    mipropiedad = false
    
    for i in 0...@propiedades.size
        if (titulo == @propiedades[i])
          mipropiedad = true
      end
      
    end
    
    mipropiedad
    
  end
  
  def estoyEnCalleLibre
    callelibre = false
    if(@casillaActual.soyEdificable && !@casillaActual.tengoPropietario)
        callelibre = true
    else
        callelibre = false
    end
    
    callelibre
  end
  
  
  def hipotecarPropiedad(titulo)
     costeHipoteca = titulo.hipotecar
     modificarSaldo(costeHipoteca)
  end
  
  def irACarcel(casilla)
    @casillaActual = casilla
    @encarcelado = true
  end
  
  def modificarSaldo(cantidad)
    #prac3
    @saldo = @saldo + cantidad
  end
  
  def obtenerCapital 
    #prac3
    @capital = @saldo #atrib insta clase
      for i in 0...@propiedades.size
        @capital = @capital + @propiedades[i].precioCompra + (@propiedades[i].numCasas + @propiedades[i].numHoteles) + @propiedades[i].precioEdificar
        if (@propiedades[i].hipotecada == true)
          @capital = @capital - @propiedades[i].hipotecaBase
        end
      end
      
    @capital
  end
  
  def obtenerPropiedades(estadoHipoteca)
    #pract3
     mispropiedades = array.new
      for i in 0...@propiedades.size
        if (@propiedades[i].hipotecada == estadoHipoteca)
          mispropiedades << @propiedades[i]
        end
      end
      return mispropiedades
  end
  
  def pagarAlquiler
    costeAlquiler = @casillaActual.pagarAlquiler
    self.modificarSaldo(-costeAlquiler)
  end
  
  def pagarImpuesto
    #prac3
    @saldo = @saldo - @casillaActual.coste
    
  end
  
  def pagarLibertad(cantidad)
    tengoSaldo = self.tengoSaldo(cantidad)
      
      if tengoSaldo
        @encarcelado = false
        self.modificarSaldo(-cantidad)
      end
  end
  
  def tengoCartaLibertad
    #prac3
    
    cartalibertad = false
    
    if(cartaLibertad != nil)
      cartalibertad = true
    end
    
    cartalibertad
  end
  
  def tengoSaldo(cantidad)
    #pract3
    sitengosaldo = false
    if(@saldo > cantidad)
      sitengosaldo = true
    end
    
    sitengosaldo
  end
  
  def venderPropiedad(casilla)
    titulo = casilla.titulo
    eliminarDeMisPropiedades(titulo)
    precioVenta = titulo.calcularPrecioVenta
    modificarSaldo(precioVenta)
  end
  
  #practica3
   def <=>( otroJugador )
     #raise NotImplementedError
     otroJugador.obtenerCapital <=> obtenerCapital # se puede hacer porque obtenerCapital devuelve un tipo basico comparable
     
   end
  
  def to_s
     texto =" "
    for i in 0...@propiedades.size
        texto += "#{@propiedades[i]}\n"
      end
    
    "Nombre: #{@nombre},
     Esta encarcelado?: #{@encarcelado},
     Saldo: #{@saldo},
     Tiene carta libertad?: #{@cartaLibertad},
     Propiedades: "+ texto +",
     Casilla actual: #{@casillaActual},
     Capital: #{@capital}"
  end
  
  def deboIrACarcel #p4
#    aux = tengoCartaLibertad
#    aux = !aux
#    return aux
    !tengoCartaLibertad
  end
  
  def convertirme(fianza) #p4
    #espe = 
    Especulador.copia(self, fianza)
  end 
  
  def puedoEdificarCasa(titulo)  #p4
    numCasas = titulo.numCasas
    return numCasas < 4
  end

  def puedoEdificarHotel(titulo)  #p4
    numHoteles = titulo.numHoteles
    numCasas = titulo.numCasas
    return (numHoteles < 4 and numCasas == 4)
  end
  
  private :eliminarDeMisPropiedades, :esDeMiPropiedad
  
  #prueba to_s
  #jugador = Jugador.new("antonio")
  #jugador.to_s
  end
end