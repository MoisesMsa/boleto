defmodule Boleto do

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

    fatores = Stream.cycle(cycle)
    fatores = Enum.take(fatores, total_digitos)

    soma_campo =
      String.split(campo, "", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.zip(fatores)
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

  # Adiciona ao fator de vencimento a data base e retorna a data original
  def fator_venc(fator) do
    {:ok, data_base} = Date.new(1997, 10, 7)
    data_nova = Date.add(data_base, fator)
  end

  # Recebe o dia, mes e ano de vencimento subtrai a data da data base para retornar o fator de vencimento
  def fator_venc(dia, mes, ano) do
    {:ok, dataBase} = Date.new(1997, 10, 7)

    {:ok, dataNova} = Date.new(ano, mes, dia)

    fator = Date.diff(dataNova, dataBase)

    # quando fator de vencimento chega em 10 mil deve retornar mil.
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

    # transforma em string e usa pad_leading para preencher o valor com zeros
    valorFinal = String.pad_leading(valorFormatado, 10, "0")
  end

  # transforma valor de dez digitos em string e divide por 100 para calcular os centavos
  def valor_decodificador(valor) do
    preco = String.to_integer(valor)
    Float.to_string(preco / 100)
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

    resto = 11 - rem(soma_campo, 11)

    if resto == 0 or resto == 10 or resto == 11 do
      1
    else
      resto
    end
  end

  def formata_data(data) do
    [dia, mes, ano] = String.split(data, "/")

    dia = String.to_integer(dia)
    mes = String.to_integer(mes)
    ano = String.to_integer(ano)

    fator_venc(dia, mes, ano)
  end

  def codificador do
    codigo_banco =
      IO.gets("Digite o código do banco (3 dígitos): \n")
      |> String.trim()
      |> String.slice(0, 3)

    moeada =
      IO.gets("Digite a moeda (Real ou outro - \"real\" ou \"outro\"): \n")
      |> String.downcase()
      |> String.trim()

    moeada = Boleto.codigo_moeda(moeada)

    data_venc =
      IO.gets("Digite a data de vencimento (dd/mm/yyy): \n")
      |> String.trim()

    fator_v = formata_data(data_venc)

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

    dados_bancarios =
      # carteira, agencia e conta não são obrigatórios para convênios de tamanho 7
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

        Enum.join([agencia, conta, carteira])
      else
        # caso nosso-número possua 17 dígitos a carteira possui esse valor padrão
        carteira = "21"
      end

    codigo_de_barras =
      Enum.join([
        codigo_banco,
        moeada,
        fator_v,
        valor_codificador(valor),
        nosso_numero,
        dados_bancarios
      ])

    dv = codigo_barras_dv(codigo_de_barras)

    codigo_de_barras = String.split_at(codigo_de_barras, 4)
    codigo_de_barras = "#{elem(codigo_de_barras, 0)}#{dv}#{elem(codigo_de_barras, 1)}"

    IO.puts("Código de barras: #{codigo_de_barras} tamanho: #{String.length(codigo_de_barras)}")
    # IO.puts("Linha digitável:")
    Barlix.ITF.encode!(codigo_de_barras) |> Barlix.PNG.print(file: "./barcode.png")
  end

  # Retorna
  # • Código do banco;
  # • Moeda;
  # • Data de vencimento (dia/mes/ano, na forma DD/MM/AAAA);
  # • valor;
  # • tipo de convenio (04, 05, o7 posições ou livre com 17 posições). Ver https://www.bb.com.br/docs/
  def decodificador(codigo_barra) do

    codigo_banco = String.slice(codigo_barra,0..2)

    IO.puts("Código banco #{codigo_banco}")
    moeda = String.at(codigo_barra, 3)

    if moeda == "9" do
      IO.puts("Moeda: Real")
    end

    if moeda == "0" do
      IO.puts("Moeda: Outro")
    end

    data_vencimento = fator_venc(String.slice(codigo_barra,5..8)
                                |> String.to_integer())

    IO.puts("Data venc: #{data_vencimento.day}/#{data_vencimento.month}/#{data_vencimento.year}")

    valor = valor_decodificador(String.slice(codigo_barra,9..18))
    IO.puts("Valor: #{valor}")

    numero_convenio = String.slice(codigo_barra,19..22)
    IO.puts("Convênio: #{numero_convenio}")

    complemento = String.slice(codigo_barra,23..29)
    IO.puts("Complemento: #{complemento}")

    agencia = String.slice(codigo_barra,30..33)
    IO.puts("Agência: #{agencia}")

    conta = String.slice(codigo_barra,34..41)
    IO.puts("Conta: #{conta}")

    carteira = String.slice(codigo_barra,42..43)
    IO.puts("Carteira: #{carteira}")

    # IO.puts("Linha digitável:")
  end
end
