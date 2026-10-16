# Identificação do MissionControl instalado

Referências obtidas em 2026-10-14 de Assets nas releases oficiais ndeadly/MissionControl, por HTTPS. Foram lidos os ZIPs, o módulo e os patches; não foram executados nem redistribuídos binários MissionControl. Os SHA-256 foram calculados localmente para comparação, não apresentados como assinatura do autor.

Arquivo a conferir no SD: atmosphere/contents/010000000000bd00/exefs.nsp. No Windows com extensões ocultas aparece como exefs, tipo Arquivo NSP. Copiar esse único arquivo para o computador permite compará-lo sem modificar o console. A presença da pasta/boot2 e o tamanho arredondado de 162 KB não identificam a versão.

| Versão oficial | Bytes de exefs.nsp | SHA-256 calculado |
|---|---:|---|
| v0.14.0 | 165813 | `ed59193cef0a8751b58e75e3d70bdb484b41b8cc4ace80712a6bacf302ee257d` |
| v0.14.1 | 165817 | `cc51c3cc404440b0257a0a4c111033417212d571c7f2fc9843c8a9531d24dd14` |
| v0.14.2 | 166310 | `4a21c9d7333d6f7944f88c2067d49c7fb5a7506e0f83fe5898c7d9abb9ce48fa` |
| v0.15.0 | 166160 | `6fc0a58dce19eab7337c83355ec7c3628e397fd4adc11b3511a726380a035d8f` |

URLs exatas dos artefatos e hashes dos ZIPs estão em [missioncontrol-reference.json](missioncontrol-reference.json).

```sh
python3 scripts/identify-missioncontrol.py /caminho/exefs.nsp
```

A ferramenta usa apenas a biblioteca padrão Python, lê o arquivo em blocos e calcula SHA-256. Código de saída 0 indica correspondência exata; 2 indica amostra não identificada. Não executa o módulo, usa rede ou escreve no arquivo. Uma amostra diferente pode ser de outra versão ou build CNX/custom; não significa automaticamente corrupção.

A identificação do arquivo não comprova que o módulo esteja carregado nem valida seus patches/compatibilidade com o telefone. No HOS 21.1.0, a release 0.14.1 introduziu suporte e documenta Atmosphère >=1.10.1. O teste do usuário em Windows já confirmou o caminho HID genérico do celular, enquanto o Switch continua falhando antes do enlace HID.
