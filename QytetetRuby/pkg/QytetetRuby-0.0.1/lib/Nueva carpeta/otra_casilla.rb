# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative "casilla"

module ModeloQytetet
  class OtraCasilla < Casilla
    
    attr_reader :tipo
    
    def initialize(numcas, tip, cost)
      super(numcas, cost)
      @tipo = tip
    end
    
    def self.newOtra(numeroCasilla, titulo, coste)
      new(numeroCasilla, titulo, coste)
    end
    
    
    def soyEdificable
        return false
    end
    
    def getTitulo
        return nil
    end 
   
    @Override
    def tengoPropietario
        return false
    end
    
    def to_s
        return super.to_s + "
              Tipo: #{@tipo} \n"
    end
    
  end
end
