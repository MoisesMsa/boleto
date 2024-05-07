defmodule Boleto do
  @moduledoc """
  Documentation for Boleto.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Boleto.codigo_moeda("real")
      9
      iex> Boleto.dv("001905009")
      5

  """
  def codigo_banco do
    001
  end

  def codigo_moeda(type) do
    moedas = %{
      "real" => 9,
      "outro" => 0
    }

    moedas[type]
  end
  ## moises
  def dv(campo) do
    #tratar string
    fatores = Stream.cycle([2, 1])
    fatores = Enum.take(fatores, 9)
    IO.puts("Fatores #{fatores}")
    IO.inspect(fatores)
    campo = String.to_atom(campo)

    IO.puts("#{campo}")
    # String.codepoints(campo)
    #   |> Enum.each(fn codepoint ->
    #     # IO.puts("#{String.to_integer(codepoint)}")
    #     # item  = String.to_integer(codepoint) * fator

    #     # fator = if fator == 2, do:  1, else: 2
    #     # IO.puts(fator)
    #     # IO.puts("Codepoint: #{item}")
    # end)


  end

  def fator_venc(fator) do
    {:ok, data_base} = Date.new(1997, 10, 7)
    data_nova = Date.add(data_base, fator)

    IO.inspect(Date.to_iso8601(data_nova))

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
  end

  ### rapahel

  def valor_codificador(preco) do

    #arredonda o valor multiplicando por 100
    valorArredondado = round(preco * 100)

    valorFormatado = Integer.to_string(valorArredondado)

    #transforma o valor em string para usar a funcao pad_leading para preencher o valor com zeros
    valorFinal = String.pad_leading(valorFormatado, 10, "0")

    IO.inspect(valorFinal)

  end

  def valor_decodificador(valor) do

    preco = String.to_integer(valor)

    IO.inspect(Float.to_string(preco/100))

    #se o valor tiver dez digitos e for do tipo binary ele transforma em uma string e divide por 100 para adicionar os centavos ao valor do codigo de barras
  end

  ## moises
  def nosso_numero do
   # caso 1 sem o dv opcao 1
   # caso 2 nosso numero livre do cliente
  end

  ### raphael
  def num_convenio do
    # numero aleatorio
  end

  ### moises
  def complemento_do_num do
  end

  ### raphael
  def num_agencia do
    #numero aleatorio
  end

  ### moises
  def conta_corrente do
  end

  ### moises
  # ou modalidade de cobrança
  def tipo_carteria do

  end

  # def linha(digitavel) do
  #   Enum.join([codigo_banco, codigo_moeda, fator_venc, valor, nosso_numero, num_convenio, complemento_do_num, num_agencia, conta_corrente, tipo_carteria])
  # end
end
