
module ModeloQytetet
  class Sorpresa

     attr_reader :texto , :valor , :tipo

    def initialize(texto, valor, tipo)
      @texto=texto
      @valor=valor
      @tipo=tipo

    end

    def to_s
      "texto: #{@texto} \n valor: #{@valor} \n tipo: #{@tipo}" 
    end
  end
end