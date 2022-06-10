require "securerandom"
require "pry"
require "pry-nav"


class Menu
    attr_accessor :enderecos, :completo, :end_completo_informado
    def programa
        puts "
           **************************************
           *******  Encurtador de Links   *******
           **************************************
       
           1 -- Encurtar endereço 
           2 -- Reverter para endereço completo 
           3 -- Listar endereços
           0 -- Sair
           \n"
            print "Digite uma opção: "
            opcao = gets.chomp.to_i
       
        case opcao
        when 1
            return {endereco: adicionar_endereco, acao: "adicionar"}
        when 2
            return {endereco: buscar_endereco, acao: "buscar"}
        when 3
            return {acao: "listar"}
        when 0
            return {acao: "sair"}
        else
            raise StandardError, 'Digite uma opção válida.'
        end
    end
    def adicionar_endereco
        puts "Digite o endereço que deseja encurtar \n"
        return @end_completo_informado = gets.chomp.to_s 
        validar_url(@end_completo_informado.to_s)
    end
    def buscar_endereco
        puts "Digite o endereço encurtado \n"
        gets.chomp.to_s    
    end
    def validar_url(end_completo_informado)
        if @end_completo_informado.include?(".com") || @end_completo_informado.include?(".gov") || @end_completo_informado.include?(".org") || @end_completo_informado.include?(".br")
            return true
        else
            return false
        end
    end
end


class Endereco
    attr_accessor :completo, :encurtado
    def initialize(completo)
        @completo = completo
        @encurtado = encurtar
    end
    def encurtar
        aleatorio = SecureRandom.hex(2)
        "helloworld.com/#{aleatorio}"
    end
end

class BancoDeEnderecos
    attr_accessor :enderecos
    def initialize
        @enderecos = []       
    end
    def add_endereco(completo)
        @novo_endereco = Endereco.new(completo)
        enderecos.push(@novo_endereco)
        puts "O endereço encurtado é #{@novo_endereco.encurtado}."
    end
    def busca_endereco(completo)
        encontrado = nil
        @enderecos.each{
            |a|
            if a.completo == completo
                encontrado = a
            end
        }
        return encontrado
    end
    def busca_endereco_encurtado(encurtado)
        encontrado = nil
        @enderecos.each{
            |b|
            if b.encurtado == encurtado
                encontrado = b
            end
        }
        return encontrado
    end
    def retornar_enderecos    
        puts "Os endereços existentes no banco de dados são:"   
        @enderecos.each{
            |c|
            puts "completo: #{c.completo}, encurtado: #{c.encurtado}"
        }      
    end
end


banco_de_enderecos = BancoDeEnderecos.new
menu = Menu.new
acao_usuario = menu.programa
validar = menu.validar_url(@end_completo_informado)


while acao_usuario[:acao] != "sair"  
    while validar == true
        if acao_usuario[:acao] == "adicionar"
            encontrado = banco_de_enderecos.busca_endereco(acao_usuario[:endereco])
            if encontrado == nil
                banco_de_enderecos.add_endereco(acao_usuario[:endereco])
            else
                puts "O endereço já estava no nosso banco de dados e o endereço encurtado é: #{encontrado.encurtado}"
            end
        elsif acao_usuario[:acao] == "buscar"
            encontrado = banco_de_enderecos.busca_endereco_encurtado(acao_usuario[:endereco])
            if encontrado == nil
                puts "Esse endereço ainda não está no nosso banco de dados."
            else
                puts "O endereço completo é: #{encontrado.completo}"
            end
        elsif acao_usuario[:acao] == "listar"
            banco_de_enderecos.retornar_enderecos
        end
        acao_usuario = menu.programa
        validar
    end
    puts 'Url inválida.'
    exit
end
