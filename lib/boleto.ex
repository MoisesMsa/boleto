defmodule Boleto do
  @moduledoc """
  Documentation for `Boleto`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Boleto.hello()
      :world

  """
  def codigo_banco do
    001
  end

  def codigo_moeda(type) do
    moedas = %{
      :real => 9,
      :other => 0
    }

    moedas[type]
  end

  def dv do
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
      IO.puts(fator - 9000)
    else
      IO.puts (fator)
    end
  end

  def valor do
  end

  def nosso_numero do
   # caso 1 sem o dv opcao 1
   # caso 2 nosso numero livre do cliente
  end

  def num_convenio do
    # caso 1 CCCCC
    # caso 2 CCCCCc
    # caso 3 CCCCCCC
    # caso 4 livre do cliente
  end

  def complemento_do_num do
  end

  def num_agencia do
  end

  def conta_corrente do
  end

  # ou modalidade de cobrança
  def tipo_carteria do

  end

  # def linha(digitavel) do
  #   Enum.join([codigo_banco, codigo_moeda, fator_venc, valor, nosso_numero, num_convenio, complemento_do_num, num_agencia, conta_corrente, tipo_carteria])
  # end
end
