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

  def codificador do
    # Digite o
    # • Código do banco;
    # • Moeda;
    # • Data de vencimento (dia/mes/ano, na forma DD/MM/AAAA);
    # • valor;
    # • tipo de convenio (04, 05, o7 posições ou livre com 17 posições). Ver https://www.bb.com.br/docs/ pub/emp/empl/dwn/Doc5175Bloqueto.pdf;
    # • Dados específicos para cada tipo de convênio
    #  retorna saida codigo de barras e linha digitavel
    code = Enum.join([codigo_banco, codigo_moeda, fator_venc, valor, nosso_numero, num_convenio, complemento_do_num, num_agencia, conta_corrente, tipo_carteria])
  end

  def codigo_barras(code) do
    Barlix.Code39.encode!(code) |> Barlix.PNG.print(file: "./barcode.png")
  end

  def decodificador do
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
  end
end
