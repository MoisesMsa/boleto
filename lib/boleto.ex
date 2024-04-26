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

  def fator_venc do
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
