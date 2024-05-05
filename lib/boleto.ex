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

    cycle = if total_digitos == 10 do
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
    proxima_dezena = (soma_campo + 10) - resto

    dv = rem(proxima_dezena - resto, 10)
  end

  def dv_barcode(campo) do
  end

  def fator_venc(fator) do
    {:ok, data_base} = Date.new(1997, 10, 7)
    Date.add(data_base, fator)
  end

  def fator_venc(dia, mes, ano) do
    {:ok, dataBase} = Date.new(1997, 10, 7)

    {:ok, dataNova} = Date.new(ano, mes, dia)

    fator = Date.diff(dataNova, dataBase)

    # necessidade pois o fator de vencimento ao chegar a 10 mil retorna a mil.
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
