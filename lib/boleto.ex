defmodule Boleto do
  @moduledoc """
  Documentation for Boleto.
  """

  @doc """
  Hello world.


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
    Date.add(data_base, fator)
  end

  def fator_venc(dia, mes, ano) do
    {:ok, dataBase} = Date.new(1997, 10, 7)

    {:ok, dataNova} = Date.new(ano, mes, dia)

    fator = Date.diff(dataNova, dataBase)

    #necessidade pois o fator de vencimento ao chegar a 10 mil retorna a mil.
    if fator >= 10000 do
      fator = fator - 9000
    end

    fator
  end

  ### rapahel
  def valor do
  end

  ## moises
  def nosso_numero do
   # caso 1 sem o dv opcao 1
   # caso 2 nosso numero livre do cliente
  end

  ### raphael
  def num_convenio do
    # caso 1 CCCCC
    # caso 2 CCCCCc
    # caso 3 CCCCCCC
    # caso 4 livre do cliente
  end

  ### moises
  def complemento_do_num do
  end

  ### raphael
  def num_agencia do
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
