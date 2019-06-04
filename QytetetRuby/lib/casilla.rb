# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative 'tipo_casilla'
require_relative 'titulo_propiedad'
module ModeloQytetet
  class Casilla
    
    attr_reader :numeroCasilla,  :tipoCasilla, :titulo
    attr_accessor :coste
    
    
    def initialize(numeroCasilla, tipo, coste)
      @numeroCasilla = numeroCasilla
      @tipoCasilla = tipo 
      @coste = coste       
      @titulo = nil
    end      
       
    #methods
    
    def getcoste
      @coste
    end
    
    def asignarPropietario(jugador)
      @titulo.propietario = jugador
    end
    
    def pagarAlquiler
      costeAlquiler = @titulo.pagarAlquiler      
      costeAlquiler
    end
    
#    def propietarioEncarcelado
#      #pract3
#      propietarioencar = false
#      
#      if(@titulo.encarcelado)
#        propietarioencar = true
#      end
#      
#      propietarioencar
#    end
    
    def soyEdificable
      #pract3
      edificable = false
      if(@tipoCasilla == TipoCasilla::CALLE)
        edificable = true
      end
      return edificable
    end
    
    def to_s
      return "\n 
              Numero de Casilla:  #{@numeroCasilla}
              Coste:  #{@coste}
              TipoCasilla: #{@tipoCasilla}"
    end

##    def tengoPropietario
##      #pract3
##      tengopro = false
##      if(@titulo.tengoPropietario)
##        tengopro = true
##      end
##      
##      tengopro      
##    end
#    
##    def to_s
##      if(titulo != nil)
##        "Casilla {Numero de la Casilla #{@numeroCasilla},
#              coste= #{@coste},
#              Tipo de la casilla = #{@tipoCasilla},
#              titulo: #{@tiulo}}#"
##      else
##        "Casilla {Numero de la Casilla #{@numeroCasilla},
#              coste= #{@coste},
#              Tipo de la casilla = #{@tipoCasilla}}#" 
##      end
##    end
##    
##    private_class_method :new
    
    
    
  end
  #casilla = Casilla.CasillaNcalle(0,TipoCasilla::SALIDA,1000)
  #puts casilla.to_s
  
end
