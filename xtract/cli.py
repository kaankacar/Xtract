import sys
from pathlib import Path
import click

from .transpiler import transpile


@click.command()
@click.argument("input", type=click.Path(exists=True, dir_okay=False, path_type=Path))
@click.argument("output", required=False, type=click.Path(dir_okay=False, path_type=Path))
def main(input: Path, output: Path | None):
    """Transpile a Solidity file to MultiversX Rust.

    INPUT: Solidity .sol file path
    OUTPUT: Optional Rust .rs output path; defaults to INPUT with .rs extension
    """
    try:
        out = output if output is not None else input.with_suffix(".rs")
        result = transpile(input, out)
        if not result:
            click.echo("Transpilation failed", err=True)
            raise SystemExit(1)
        click.echo(f"Wrote {out}")
    except Exception as exc:
        click.echo(f"Error: {exc}", err=True)
        raise SystemExit(1)


if __name__ == "__main__":
    main()


