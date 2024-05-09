defmodule Boleto do
  @moduledoc """
  Documentation for Boleto.
  """

  @doc """
  Hello world.


  """
  def main do
    IO.puts(">>>>>>>>> teste")
    #  |>
  end

  def codigo_banco do
    001
  end

  # def string_para_lista_numerica(string) do
  #   # IO.inspect({string, :erlang.element(1, :erlang.type(string))})
  #   string
  #   |> String.graphemes()
  #   |> Enum.map(&String.to_integer/1)
  # end

  def codigo_moeda(type) do
    moedas = %{
      "real" => 9,
      "outro" => 0
    }

    moedas[type]
  end

  ## moises
  def dv_line(campo) do
    total_digitos = String.length(campo)

    cycle =
      if total_digitos == 10 do
        [1, 2]
      else
        [2, 1]
      end

    # IO.inspect(cycle)

    fatores = Stream.cycle(cycle)
    fatores = Enum.take(fatores, total_digitos)

    # tratar string
    soma_campo =
      String.split(campo, "", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.zip(fatores)
      ## refatorar
      |> Enum.map(fn {x, y} ->
        value = x * y

        if value > 9 do
          value = value - 10 + 1
        else
          value
        end
      end)
      |> Enum.sum()

    resto = rem(soma_campo, 10)
    proxima_dezena = soma_campo + 10 - resto

    dv = rem(proxima_dezena - resto, 10)
  end

  def dv_barcode(campo) do
  end

  def fator_venc(fator) do
    fator_int = String.to_integer(fator)
    {:ok, data_base} = Date.new(1997, 10, 7)
    data_nova = Date.add(data_base, fator_int)

    Date.to_iso8601(data_nova)

    #{year, month, day} = {data_nova.year, data_nova.month, data_nova.day}
    #ao receber o fator de vencimento essa funcao adiciona ele a data base para retornar o dia, mes e ano da data de vencimento

  end

  def fator_venc(dia, mes, ano) do
    {:ok, dataBase} = Date.new(1997, 10, 7)

    {:ok, dataNova} = Date.new(ano, mes, dia)

    fator = Date.diff(dataNova, dataBase)

    #ao receber o dia, mes e ano de vencimento a funcao subtrae a data da data base para retornar o fator de vencimento
    #necessidade pois o fator de vencimento ao chegar a 10 mil retorna a mil.
    if fator >= 10000 do
      fator - 9000
    else
      fator
    end

    fator
  end

  ### rapahel

  def valor_codificador(preco) do

    #arredonda o valor multiplicando por 100
    valorArredondado = round(preco * 100)

    valorFormatado = Integer.to_string(valorArredondado)

    #transforma o valor em string para usar a funcao pad_leading para preencher o valor com zeros
    valorFinal = String.pad_leading(valorFormatado, 10, "0")

    valorFinal

  end

  def valor_decodificador(valor) do

    preco = String.to_integer(valor)

    Float.to_string(preco/100)

    #se o valor tiver dez digitos e for do tipo binary ele transforma em uma string e divide por 100 para adicionar os centavos ao valor do codigo de barras
  end

  ## moises
  def nosso_numero(campo) do
    total_digitos = String.length(campo)

    fatores = Stream.cycle([9, 8, 7, 6, 5, 4, 3, 2])

    fatores =
      Enum.take(fatores, total_digitos)
      |> Enum.reverse()

    # tratar string
    soma_campo =
      String.split(campo, "", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.zip(fatores)
      ## refatorar
      |> Enum.map(fn {x, y} -> value = x * y end)
      |> Enum.sum()

    resto = rem(soma_campo, 11)

    dv =
      cond do
        resto < 10 ->
          resto

        resto == 10 ->
          "X"
      end
  end

  ### moises
  def complemento_do_num do
  end

  # ### aleatorio
  # def num_convenio do
  #   # caso 1 CCCCC
  #   # caso 2 CCCCCc
  #   # caso 3 CCCCCCC
  #   # caso 4 livre do cliente
  # end

  # ### aleatorio
  # def num_agencia do
  # end

  # ### aleatorio
  # def conta_corrente do
  # end

  # ### aleatorio
  # def tipo_carteria do
  # end

  # def linha(digitavel) do
  #   Enum.join([codigo_banco, codigo_moeda, fator_venc, valor, nosso_numero, num_convenio, complemento_do_num, num_agencia, conta_corrente, tipo_carteria])
  # end

  def formata_data(data) do
    [dia, mes, ano] = String.split(data, "/")
    {String.to_integer(dia), String.to_integer(mes), String.to_integer(ano)}
    fator_venc(dia, mes, ano)
  end

  def codificador(moeda, data, valor) do
    # Digite o
    # • Código do banco;
    # • Moeda;
    # • Data de vencimento (dia/mes/ano, na forma DD/MM/AAAA);
    # • valor;
    # • tipo de convenio (04, 05, o7 posições ou livre com 17 posições). Ver https://www.bb.com.br/docs/ pub/emp/empl/dwn/Doc5175Bloqueto.pdf;
    # • Dados específicos para cada tipo de convênio
    #  retorna saida codigo de barras e linha digitavel

    [dia, mes, ano] = formata_data(data)
    codigo_banco = codigo_banco()
    codigo_moeda = codigo_moeda(moeda)
    fator_venc = fator_venc(dia, mes, ano)
    valor = valor_codificador(valor)

    #entre codigo moeda e fator vencimento tem que adicionar dv do codigo de barras e após valores são apenas numeros aleatorios.
    code = Enum.join([codigo_banco, codigo_moeda, fator_venc, valor, nosso_numero, num_convenio, complemento_do_num, num_agencia, conta_corrente, tipo_carteria])
  end

  def codigo_barras(code) do
    Barlix.Code39.encode!(code) |> Barlix.PNG.print(file: "./barcode.png")
  end

  def decodificador(codigo_barra) do
    # Digite linha digitavel com os 44 elementos
    # Retorna
    # • Linha digitável;
    # • Código do banco;
    # • Moeda;
    # • Data de vencimento (dia/mes/ano, na forma DD/MM/AAAA);
    # • valor;
    # • tipo de convenio (04, 05, o7 posições ou livre com 17 posições). Ver https://www.bb.com.br/docs/
    # pub/emp/empl/dwn/Doc5175Bloqueto.pdf;
    # • Dados específicos para cada tipo de convênio


    codigo_banco = String.slice(codigo_barra,0..2)
    IO.gets(codigo_banco)
    moeda = String.at(codigo_barra, 3)
    if moeda == "9" do
      IO.gets("Real")
    end
    if moeda == "0" do
      IO.gets("Outro")
    end
    data_vencimento = fator_venc(String.slice(codigo_barra,5..8))
    IO.gets(data_vencimento)
    valor = valor_decodificador(String.slice(codigo_barra,9..18))
    IO.gets(valor)
    numero_convenio = String.slice(codigo_barra,19..22)
    IO.gets(numero_convenio)
    complemento = String.slice(codigo_barra,23..29)
    IO.gets(complemento)
    agencia = String.slice(codigo_barra,30..33)
    IO.gets(agencia)
    conta = String.slice(codigo_barra,34..41)
    IO.gets(conta)
    carteira = String.slice(codigo_barra,42..43)
    IO.gets(carteira)
  end
end
