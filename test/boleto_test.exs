defmodule BoletoTest do
  use ExUnit.Case
  doctest Boleto

  test "retorna real" do
    assert Boleto.codigo_moeda("real") == 9
  end

  test "código de barras para fator de vencimento" do
    assert Date.to_iso8601(Boleto.fator_venc(1000)) == "2000-07-03"
  end

  test "data para fator de vencimento" do
    IO.puts(Boleto.fator_venc(03, 07, 2000))
    assert Boleto.fator_venc(03, 07, 2000) == 1000
  end

  test "digito verificador igual a 5" do
    assert Boleto.dv_line("001905009") == 5
  end

  test "digito verificador igual a 9" do
    assert Boleto.dv_line("4014481606") == 9
  end

  test "digito verificador igual a 4" do
    assert Boleto.dv_line("0680935031") == 4
  end

  # código do Beneficiário e prefixo da agência
  test "nosso numero 05009401448-1" do
    assert Boleto.nosso_numero_dv("05009401448") == "1"
  end

  test "digito verifcador do boleto igual a 3" do
    assert Boleto.codigo_barras_dv("0019373700000001000500940144816060680935031") == 3
  end
end
