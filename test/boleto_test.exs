defmodule BoletoTest do
  use ExUnit.Case
  doctest Boleto

  test "retorna real" do
    assert Boleto.codigo_moeda("real") == 9
  end

  test "digito verificador igual a 5" do
    assert Boleto.dv("001905009") == 5
  end

  # test "digito verificador igual a 9" do
  #   assert Boleto.dv("4014481606") == 9
  # end

  # test "digito verificador igual a 4" do
  #   assert Boleto.dv("0680935031") == 4
  # end

  ## tamanho da linha 44 itens
  ## tamanho da linha 47 itens
  ## valor do dv calculado corretemente
end
