clear all;
close all;
clc;

freqAmostragem = 500000  % frequencia de amostragem (PS_8 no Arduino)
freqSinal = 20000        % frequencia do sinal
numeroMaximoDeAmostras = 500;

periodoAmostragem = 1.0/freqAmostragem
periodoSinal = 1.0/freqSinal
pontosPorCiclo = periodoSinal/periodoAmostragem;
numeroDeCiclos = floor(numeroMaximoDeAmostras/pontosPorCiclo)
vetorTempos = 0:periodoAmostragem:periodoSinal*numeroDeCiclos;

seno = sin(2*pi*freqSinal*vetorTempos);
cosseno = cos(2*pi*freqSinal*vetorTempos);

E = [seno' cosseno' ones(length(vetorTempos),1)];
piE = pinv(E); % pseudo-inversa de E - pode ser calculada offline!!!

% gravamos a piE no STM32... a multiplicação a seguir é feita dentro do STM32,
% e está aqui apenas como demonstração de funcionamento.
%
% o arquivos frame.txt contém um conjunto de dados coletados pelo arduino


disp(['Usando ' num2str(length(vetorTempos)) ' pontos medidos:'])


dados = [2313
2340
2340
2239
2248
2147
2105
2009
1975
1839
1845
1736
1777
1710
1773
1736
1850
1830
1968
1981
2133
2149
2261
2238
2356
2294
2389
2331
2322
2216
2201
2060
2034
1970
1903
1841
1802
1768
1760
1764
1804
1851
1915
1988
2064
2130
2210
2260
2327
2353
2384
2368
2346
2299
2246
2164
2093
2013
1953
1871
1827
1787
1772
1747
1774
1796
1862
1919
2006
2076
2146
2203
2281
2326
2363
2370
2364
2333
2290
2222
2162
2077
2005
1937
1877
1828
1790
1745
1763
1768
1817
1861
1940
2002
2095
2139
2226
2272
2337
2356
2376
2351
2328
2259
2215
2136
2073
1985
1921
1854
1792
1770
1744
1751
1771
1812
1872
1944
2019
2094
2162
2219
2288
2325
2362
2361
2343
2303
2280
2199
2140
2045
1988
1907
1873
1798
1799
1753
1776
1780
1858
1890
1993
2035
2139
2165
2255
2294
2370
2365
2396
2345
2314
2260
2201
2119
2049
1962
1891
1837
1790
1768
1754
1762
1784
1841
1903
1972
2037
2116
2168
2246
2295
2348
2359
2368
2316
2293
2218
2175
2092
2022
1931
1874
1812
1782
1751
1752
1749
1799
1834
1907
1963
2052
2095
2199
2236
2315
2326
2366
2329
2331
2258
2226
2134
2090
1976
1974
1850
1847
1761
1775
1730
1839
1776
1911
1893
2045
2044
2258
2170
2373
2287
2464
2327
2472
2286
2400
2187
2277
2038
2114
1887
1976
1789
1899
1733
1855
1742
1912
1832
2041
1984
2194
2115
2338
2245
2444
2327
2461
2308
2421
2236
2313
2103
2142
1948
1998
1831
1893
1745
1758
1734
1792
1794
1904
1921
1995
2068
2136
2204
2263
2309
2327
2333
2312
2284
2230
2180
2112
2025
1979
1893
1861
1737
1777
1713
1774
1779
1885
1840
1974
1985
2154
2139
2265
2253
2371
2335
2384
2315
2315
2238
2195
2098
2042
1973
1900
1843
1808
1786
1764
1779
1801
1857
1925
2000
2062
2160
2194
2279
2322
2377
2372
2398
2337
2307
2237
2192
2095
2048
1944
1896
1826
1798
1761
1771
1761
1801
1858
1903
1992
2056
2130
2176
2280
2286
2358
2347
2371
2310
2286
2210
2158
2077
2001
1925
1871
1813
1775
1760
1759
1775
1818
1860
1938
2004
2093
2152
2240
2278
2355
2378
2393
2342
2354
2270
2242
2142
2098
1949
1945
1824
1829
1733
1775
1720
1805
1788
1896
1900
2036
2042
2190
2171
2312
2273
2384
2316
2374
2270
2291
2160
2159
2015
2006
1884
1874
1776
1785
1774
1773
1807
1841
1902
1967
2028
2113
2179
2251
2306
2354
2369
2408
2355
2362
2267
2245
2122
2048
1967
1906
1848
1789
1770
1756
1767
1790
1834
1894
1969
2040
2122
2180
2252
2304
2349
2368
2368
2352
2311
2260
2187
2104
2031
1962
1899
1837
1802
1774
1764
1773
1802
1855
1901
1977
2052
2126
2186
2262
2311
2354
2370
2366
2346
2302
2249
2170
2108
2019
1962
1887
1839
1790
1776
1760
1783
1808
1872
1925
2008
2076
2151
2210
2297
2293
2373
2324
2388
2292
];
plot(dados)


disp('')
disp('*******************************************************************')
disp('Primeiro modo')

% conta a ser feita no arduino, com os dados coletados :
resp = piE*dados(1:length(vetorTempos));
R(1) = sqrt(resp(1)^2+resp(2)^2); %Amplitude
R(2) = atan(resp(2)/resp(1)); %Fase
R(3) = resp(3); %Offset
R(4) = length(vetorTempos); %N amostras
R

disp(['Amplitude do sinal: ' num2str(R(1))]);
disp(['Fase do sinal: ' num2str(R(2))]);
disp(['Offset do sinal: ' num2str(R(3))]);
disp(['Número de pontos utilizados: ' num2str(R(4)) ])


% este é um modo mais simples de fazer a mesma coisa no arduino ou STM32
disp('')
disp('*******************************************************************')
disp('Segundo modo')

piEvec = reshape(piE',1,length(vetorTempos)*3);
valorseno = 0;
valorcosseno = 0;
for i = 1:length(vetorTempos)
    valorseno = valorseno + dados(i)*(piEvec(i));
    valorcosseno = valorcosseno + dados(i)*(piEvec(i+length(vetorTempos)));
end
valorseno
valorcosseno
disp('Com o valorseno e valorcosseno, conseguimos calcular a amplitude e a fase:')
amplitude = sqrt(valorseno*valorseno + valorcosseno*valorcosseno)
fase = atan(valorcosseno/valorseno)






