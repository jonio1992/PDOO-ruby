# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative "casilla"
require_relative "titulo_propiedad"
require_relative "tipo_casilla"
module ModeloQytetet
  class Calle < Casilla
    
    attr_accessor :titulo
    
    def initialize(numcas, tit)
      super(numcas,TipoCasilla::CALLE,tit.precioCompra )
      @titulo = tit
    end
    
     def self.newCalle(numeroCasilla, titulo)
      new(numeroCasilla, titulo)
     end
     
      def asignarPropietario(jugador)
      @titulo.propietario(jugador)
    end
    
    def getTipo
       return TipoCasilla::CALLE
    end
        
    
    def pagarAlquiler
      costeAlquiler = @titulo.pagarAlquiler
      return costeAlquiler;
    end
    
    
    def soyEdificable
      #Devuelve cierto sólo si es una casilla de tipo CALLE.
        return true
    end
    
    
    def tengoPropietario
      return @titulo.tengoPropietario
    end
    
    def to_s
      return super.to_s + "
              Tipo: CALLE  
              Titulo: #{@titulo} \n"
    end
    
  end
end
