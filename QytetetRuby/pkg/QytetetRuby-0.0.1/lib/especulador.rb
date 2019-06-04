# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
#require_relative "jugador"
#require_relative "titulo_propiedad"

module ModeloQytetet
  class Jugador
  end
  
  class Especulador < Jugador
    attr_accessor :fianza
    
#    def initialize(jugador, fia)
#      super(jugador.nombre, jugador.encarcelado,  jugador.saldo, jugador.cartaLibertad , jugador.casillaActual , jugador.propiedades )
#      @fianza = fia
#    end
    
    def self.copia(unJugador, fianza)
      espec = super(unJugador)
      espec.fianza = fianza
      espec
       #new(unJugador, fianza)
    end
    private_class_method :new
    
     def pagarImpuesto(cantidad)
       #super.pagarImpuesto(-cantidad/2)
       @saldo = @saldo - @casillaActual.coste/2
     end
    
    def convertirme(fianza)
        #return null;#Especulador
        return self
    end
    
    def deboIrACarcel()
#      aux = false
#      if(super.deboIrACarcel == true && pagarFianza == false)
#        aux = true       
#      end
      
      aux = super and !pagarFianza
        
      return aux
    end
    
    def pagarFianza
      tengo = self.tengoSaldo(@fianza);
      if(tengo)
        self.modificarSaldo(-@fianza)
      end
      return tengo
    end
    
    def puedoEdificarCasa(titulo)
        numCasas = titulo.numCasas
        return numCasas < 8
    
    end    
    
    def puedoEdificarHotel(titulo)
      numCasas = titulo.numCasas
      numHoteles = titulo.numHoteles
      return numCasas >= 4 && numHoteles < 8
    
    end
    
#    def comprarTituloPropiedad
#    comprado = false
#    costeCompra = @casillaActual.coste
#      
#      if costeCompra < @saldo
#        comprado = true
#        @casillaActual.titulo.propietario = self
#        @propiedades << @casillaActual.titulo
#        self.modificarSaldo(-costeCompra)
#      end
#      
#      comprado
#  end
    
    def to_s
      return super.to_s + "Fianza: #{@fianza}\n"
    end
    
     
  end
end
