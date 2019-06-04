# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require_relative "jugador"
module ModeloQytetet

class TituloPropiedad
  attr_accessor :hipotecada, :propietario, :numCasas, :numHoteles
  attr_reader :nombre, :precioCompra, :alquilerBase, 
              :factorRevalorizacion, :hipotecaBase, :precioEdificar
              
  
  def initialize(n, aprecio, aBase, fReva, hBase, pEdi)
    @nombre=n
    @hipotecada=false
    @precioCompra=aprecio
    @alquilerBase=aBase
    @factorRevalorizacion=fReva
    @hipotecaBase=hBase   
    @precioEdificar=pEdi
    @numHoteles=0
    @numCasas=0
    @casilla = nil
    @propietario = nil
  end
  
  #methods
  
  def calcularCosteCancelar
    costeCancelar = calcularCosteHipotecar
    costeCancelar = costeCancelar + (costeCancelar * 0.1)
    costeCancelar.to_i
  end
  
  def calcularCosteHipotecar
    return (@hipotecaBase + @numCasas * 0.5 * @hipotecaBase + @numHoteles * @hipotecaBase).to_i
  end
  
  def calcularImporteAlquiler
    return costeAlquiler = @alquilerBase + (@numCasas * 0.5 + @numHoteles * 2).to_i
  end
  
  def calcularPrecioVenta
    return (@precioCompra + ( @numCasas + @numHoteles ) * @precioEdificar * @factorRevalorizacion).to_i
  end
  
  def cancelarHipoteca
    @hipotecada = false
    return true
    
  end
  
  def cobrarAlquiler(coste)
    NotImplementedError
  end
  
  def edificarCasa
     @numCasas = @numCasas + 1
  end
  
  def edificarHotel()
    @numHoteles = @numHoteles + 1
    #@numCasas = 0
  end
  
  def hipotecar
    @hipotecada = true
    costeHipoteca = calcularCosteHipotecar
    costeHipoteca
  end
  
  def pagarAlquiler
    costeAlquiler = calcularImporteAlquiler
    @propietario.modificarSaldo(costeAlquiler)
    costeAlquiler
  end
  
  def propietarioEncarcelado
    @propietario.encarcelado
  end
  
  def tengoPropietario
    if(@propietario == nil)
      return false
    else
      return true
    end
  end
  
  def to_s
    texto = "
              Nombre propiedad: #{@nombre}
              Hipotecada: "
        
    if@hipotecada == true
      texto << "Si"
    else
      texto << "No"
    end
    
    texto << "
              Precio de compra: #{@precioCompra}
              Alquiler base: #{@alquilerBase}
              Factor de revalorizacion: #{@factorRevalorizacion}
              Hipoteca base: #{@hipotecaBase}
              Precio de edificar: #{@precioEdificar}
              Numero de hoteles/casas: #{@numHoteles}/#{@numCasas}"
        
    
    
=begin  
    "TituloPropiedad {\n nombre=  #{@nombre},
                \n hipotecada=  #{@hipotecada},
                \n precio= #{@precioCompra} ,
                \n alquilerBase= #{@alquilerBase},
                \n factorRevalorizacion= #{@factorRevalorizacion},
                \n hipotecaBase= #{@hipotecaBase},
                \n precioEdificar= #{@precioEdificar},
                \n hipotecaBase= #{@numHoteles},
                \n precioEdificar= #{@numCasas},
                \n}"
=end
    
  end
end
end