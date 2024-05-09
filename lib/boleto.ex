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
    type =
          if(type != "real") do
            "outro"
          else
            type
          end

    moedas = %{
      "real" => 9,
      "outro" => 0
    }

    moedas[type]
  end

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

  def fator_venc(fator) do
    {:ok, data_base} = Date.new(1997, 10, 7)
    data_nova = Date.add(data_base, fator)

    # {year, month, day} = {data_nova.year, data_nova.month, data_nova.day}

    # ao receber o fator de vencimento essa funcao adiciona ele a data base para retornar o dia, mes e ano da data de vencimento
  end

  def fator_venc(dia, mes, ano) do
    {:ok, dataBase} = Date.new(1997, 10, 7)

    {:ok, dataNova} = Date.new(ano, mes, dia)

    fator = Date.diff(dataNova, dataBase)

    # ao receber o dia, mes e ano de vencimento a funcao subtrae a data da data base para retornar o fator de vencimento
    # necessidade pois o fator de vencimento ao chegar a 10 mil retorna a mil.
    if fator >= 10000 do
      fator - 9000
    else
      fator
    end
  end


  def valor_codificador(preco) do
    # arredonda o valor multiplicando por 100
    valorArredondado = round(preco * 100)

    valorFormatado = Integer.to_string(valorArredondado)

    # transforma o valor em string para usar a funcao pad_leading para preencher o valor com zeros
    valorFinal = String.pad_leading(valorFormatado, 10, "0")
  end

  def valor_decodificador(valor) do
    preco = String.to_integer(valor)

    IO.inspect(Float.to_string(preco / 100))

    # se o valor tiver dez digitos e for do tipo binary ele transforma em uma string e divide por 100 para adicionar os centavos ao valor do codigo de barras
  end

  def nosso_numero_dv(campo) do
    total_digitos = String.length(campo)

    if total_digitos == 17 do
      ""
    else
      fatores = Stream.cycle([9, 8, 7, 6, 5, 4, 3, 2])

      fatores =
        Enum.take(fatores, total_digitos)
        |> Enum.reverse()

      soma_campo =
        String.split(campo, "", trim: true)
        |> Enum.map(&String.to_integer/1)
        |> Enum.zip(fatores)
        |> Enum.map(fn {x, y} -> value = x * y end)
        |> Enum.sum()

      resto = rem(soma_campo, 11)

      dv =
        cond do
          resto < 10 ->
            Integer.to_string(resto)

          resto == 10 ->
            "X"
        end
    end
  end

  def codigo_barras_dv(campos) do
    total_digitos = String.length(campos)
    fatores = Stream.cycle([2, 3, 4, 5, 6, 7, 8, 9])

    fatores =
              Enum.take(fatores, total_digitos)
              |> Enum.reverse()

    soma_campo =
                String.split(campos, "", trim: true)
                |> Enum.map(&String.to_integer/1)
                |> Enum.zip(fatores)
                |> Enum.map(fn {x, y} -> value = x * y end)
                |> Enum.sum()

    # só muda essa parte aqui
    resto = 11 - rem(soma_campo, 11)

    if resto == 0 or resto == 10 or resto == 11 do
      1
    else
      resto
    end
  end

  def codificador do
    codigo_banco =
      IO.gets("Digite o código do banco (3 dígitos): \n")
      |> String.trim()
      |> String.slice(0, 3)

    moeada =
      IO.gets("Digite a moeda (Real ou outro - 1 dígito): \n")
      |> String.downcase()
      |> String.trim()

    moeada = Boleto.codigo_moeda(moeada)

    dia_venc =
      IO.gets("Digite o dia de vencimento (dd - 2 dígitos): \n")
      |> String.trim()
      |> String.to_integer()

    mes_venc =
      IO.gets("Digite o mês de vecimento (mm - 2 dígitos): \n")
      |> String.trim()
      |> String.to_integer()

    ano_venc =
      IO.gets("Digite o ano de vecimento (yyyy - 4 dígitos): \n")
      |> String.trim()
      |> String.to_integer()

    valor =
      IO.gets("Digite o valor (formato: 0.00):\n")
      |> String.trim()
      |> String.to_float()

    convenio =
      IO.gets("Digite o número de convênio (4, 6 ou 7 dígitos): \n")
      |> String.trim()

    convenio_size = String.length(convenio)

    if convenio_size != 4 and convenio_size != 6 and convenio_size != 7 do
      IO.puts("Tamanho do convênio inválido, inicie novamente. #{convenio_size} dígitos")
      System.halt(1)
    end

    complemento_size =
      cond do
        convenio_size < 7 ->
          11 - convenio_size

        convenio_size == 7 ->
          10
      end

    complemento =
      IO.gets("Digite o o complemento do nosso-número (#{complemento_size} dígitos): \n")
      |> String.trim()
      |> String.slice(0, complemento_size)

    nosso_numero = convenio <> complemento
    nosso_numero = nosso_numero <> nosso_numero_dv(nosso_numero)

    agencia = ""
    conta = ""
    # caso nosso número possua 17 dígitos
    carteira = "21"

    if convenio_size < 7 do
      agencia =
                IO.gets("Digite o número da agência (4 dígitos): \n")
                |> String.trim()
                |> String.slice(0, 4)

      conta =
              IO.gets("Digite o número da conta sem dv (8 dígitos): \n")
              |> String.trim()
              |> String.slice(0, 8)

      carteira =
                IO.gets("Digite o número da carteira (2 dígitos): \n")
                |> String.trim()
                |> String.slice(0, 2)
    end


      codigo_de_barras = Enum.join([
        codigo_banco,
        moeada,
        fator_venc(
          dia_venc,
          mes_venc,
          ano_venc
        ),
        valor_codificador(valor),
        nosso_numero,
        agencia,
        conta,
        carteira
      ])

      dv = codigo_barras_dv(codigo_de_barras)

      codigo_de_barras = String.split_at(codigo_de_barras, 4)
      codigo_de_barras = "#{elem(codigo_de_barras, 0)}#{dv}#{elem(codigo_de_barras, 1)}"

      Barlix.Code39.encode!(codigo_de_barras) |> Barlix.PNG.print(file: "./barcode.png")
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
