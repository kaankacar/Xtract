import sys
from pathlib import Path
from typing import Optional
import click

from .transpiler import transpile, transpile_with_diagnostics


@click.command()
@click.argument("input", type=click.Path(exists=True, dir_okay=False, path_type=Path))
@click.argument("output", required=False, type=click.Path(dir_okay=False, path_type=Path))
@click.option("-v", "--verbose", is_flag=True, help="Show detailed diagnostics and warnings")
@click.option("-q", "--quiet", is_flag=True, help="Suppress all output except errors")
def main(input: Path, output: Optional[Path], verbose: bool, quiet: bool):
    """Transpile a Solidity file to MultiversX Rust.

    INPUT: Solidity .sol file path
    OUTPUT: Optional Rust .rs output path; defaults to INPUT with .rs extension
    """
    try:
        out = output if output is not None else input.with_suffix(".rs")

        if verbose:
            result = transpile_with_diagnostics(input, out)

            # Show warnings
            if result.warnings:
                click.echo(click.style("\nDiagnostics:", fg="yellow", bold=True))
                for warning in result.warnings:
                    color = "yellow" if warning.severity == "warning" else "cyan"
                    prefix = "⚠️ " if warning.severity == "warning" else "ℹ️ "
                    click.echo(click.style(f"  {prefix}{warning.message}", fg=color))

            # Show errors
            if result.errors:
                click.echo(click.style("\nErrors:", fg="red", bold=True))
                for error in result.errors:
                    click.echo(click.style(f"  ❌ {error}", fg="red"))

            if not result.success:
                click.echo(click.style("\nTranspilation failed", fg="red"), err=True)
                raise SystemExit(1)

            if not quiet:
                click.echo(click.style(f"\n✅ Wrote {out}", fg="green"))
        else:
            success = transpile(input, out)
            if not success:
                click.echo("Transpilation failed", err=True)
                raise SystemExit(1)
            if not quiet:
                click.echo(f"Wrote {out}")

    except Exception as exc:
        click.echo(f"Error: {exc}", err=True)
        raise SystemExit(1)


if __name__ == "__main__":
    main()
