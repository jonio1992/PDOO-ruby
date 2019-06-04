# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.
require_relative 'casilla'
require_relative 'calle'
#require_relative 'otra_casilla'
require_relative 'titulo_propiedad'
require_relative 'tipo_casilla'

module ModeloQytetet

  class Tablero

    attr_reader :carcel, :casillas


    def initialize
      inicializar
    end
     #methods

    def inicializar
      @casillas = Array.new

      @casillas<< Casilla.new(0,TipoCasilla::SALIDA,1000)
      #t= TituloPropiedad.new("calle Cereza",500,50,10,150,250)
      #puts t.precioCompra.inspect

      @casillas<< Calle.newCalle(1,TituloPropiedad.new("calle Cereza",500,50,10,150,250))
      @casillas<< Calle.newCalle(2,TituloPropiedad.new("calle Fresa",500,50,10,150,250))
      @casillas<< Casilla.new(3,TipoCasilla::SORPRESA,0)
      @casillas<< Calle.newCalle(4,TituloPropiedad.new("calle Pera",550,50,10,150,250))
      @casillas<< Calle.newCalle(5,TituloPropiedad.new("calle Platano",550,50,10,150,250))
      @casillas<< Calle.newCalle(6,TituloPropiedad.new("calle Naranja",550,50,10,150,250))
      @casillas<< Casilla.new(7,TipoCasilla::CARCEL,0)
      @casillas<< Calle.newCalle(8,TituloPropiedad.new("calle Manzana",600,50,10,150,250))
      @casillas<< Calle.newCalle(9,TituloPropiedad.new("calle Mango",600,50,10,150,250))
      @casillas<< Casilla.new(10,TipoCasilla::PARKING,0)
      @casillas<< Casilla.new(11,TipoCasilla::SORPRESA,0)
      @casillas<< Calle.newCalle(12,TituloPropiedad.new("calle Coco",700,50,10,150,250))
      @casillas<< Calle.newCalle(13,TituloPropiedad.new("calle Melocoton",700,50,10,150,250))
      @casillas<< Casilla.new(14,TipoCasilla::JUEZ,0)
      @casillas<< Calle.newCalle(15,TituloPropiedad.new("calle Pinia",700,50,10,150,250))
      @casillas<< Calle.newCalle(16,TituloPropiedad.new("calle Melon",850,50,10,150,250))
      @casillas<< Casilla.new(17,TipoCasilla::SORPRESA,0)
      @casillas<< Casilla.new(18,TipoCasilla::IMPUESTO,0)
      @casillas<< Calle.newCalle(19,TituloPropiedad.new("calle Sandia",1000,50,10,150,250))

      #senialar carcel
      #@carcel = @casillas.at(7)
      @carcel = Casilla.new(7,TipoCasilla::CARCEL,0)
    end

    def esCasillaCarcel(numeroCasilla)
      escarcel = false

      if( numeroCasilla == carcel)
        escarcel = true
      end

      return escarcel
    end    

    def obtenerCasillaNumero(numeroCasilla)
      #puts '****************'
      #puts @casillas.inspect

  #    for i in @casillas
  #      if(i.numeroCasilla == numeroCasilla)
  #        if(i.titulo != nil)
  #          casilla = Casilla.Casillacalle(i.numeroCasilla,i.titulo)
  #        else
  #          casilla = Casilla.CasillaNcalle(i.numeroCasilla,TipoCasilla::SORPRESA,0)
  #        end
  #      end
  #    end
  #    
  #      return casilla

      if(numeroCasilla < 0 || numeroCasilla > @casillas.size())
          return nil
        else
          return @casillas[numeroCasilla]
        end
    end

    def obtenerCasillaFinal( casilla, desplazamiento)

  #    auxcasilla = (casilla.numeroCasilla + desplazamiento) % 20
  #    for i in @casillas
  #      if(i.numeroCasilla == auxcasilla)
  #        if(i.titulo != nil)
  #          casilla = Casilla.Casillacalle(i.numeroCasilla,i.titulo)
  #        else
  #          casilla = Casilla.CasillaNcalle(i.numeroCasilla,TipoCasilla::SORPRESA,0)
  #        end
  #      end
  #    end
  #    
  #    return casilla
      pos = casilla.numeroCasilla
      pos += desplazamiento
      pos = pos%(@casillas.size())
      return @casillas.at(pos)

    end

    def to_s
      texto = " "
      @casillas.each {|i| texto = texto + i.to_s} 
      "El Tablero de juego es: " + texto
      #puts "El Tablero de juego es: \n#{@casillas}"  
    end

   # tablero = Tablero.new
   # puts tablero.to_s

  end
end