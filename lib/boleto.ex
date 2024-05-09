defmodule Boleto do

  def main do
    IO.puts(">>>>>>>>> teste")
  end

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

  def dv_barcode(campo) do
  end

  def fator_venc(fator) do
    fator_int = String.to_integer(fator)
    {:ok, data_base} = Date.new(1997, 10, 7)
    data_nova = Date.add(data_base, fator_int)

    Date.to_iso8601(data_nova)

  end

  def fator_venc(dia, mes, ano) do
    {:ok, dataBase} = Date.new(1997, 10, 7)

    {:ok, dataNova} = Date.new(ano, mes, dia)

    fator = Date.diff(dataNova, dataBase)


    if fator >= 10000 do
      fator - 9000
    else
      fator
    end

    fator
  end



  def valor_codificador(preco) do


    valorArredondado = round(preco * 100)

    valorFormatado = Integer.to_string(valorArredondado)


    valorFinal = String.pad_leading(valorFormatado, 10, "0")

    valorFinal

  end

  def valor_decodificador(valor) do

    preco = String.to_integer(valor)

    Float.to_string(preco/100)


  end


  def nosso_numero(campo) do
    total_digitos = String.length(campo)

    fatores = Stream.cycle([9, 8, 7, 6, 5, 4, 3, 2])

    fatores =
      Enum.take(fatores, total_digitos)
      |> Enum.reverse()


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


  def complemento_do_num do
  end


  def formata_data(data) do
    [dia, mes, ano] = String.split(data, "/")
    {String.to_integer(dia), String.to_integer(mes), String.to_integer(ano)}
    fator_venc(dia, mes, ano)
  end

  def codificador(moeda, data, valor) do


    [dia, mes, ano] = formata_data(data)
    codigo_banco = codigo_banco()
    codigo_moeda = codigo_moeda(moeda)
    fator_venc = fator_venc(dia, mes, ano)
    valor = valor_codificador(valor)


    code = Enum.join([codigo_banco, codigo_moeda, fator_venc, valor, nosso_numero, num_convenio, complemento_do_num, num_agencia, conta_corrente, tipo_carteria])
  end

  def codigo_barras(code) do
    Barlix.Code39.encode!(code) |> Barlix.PNG.print(file: "./barcode.png")
  end

  def decodificador(codigo_barra) do


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
