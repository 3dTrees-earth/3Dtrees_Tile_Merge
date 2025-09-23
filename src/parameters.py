from pydantic_settings import BaseSettings, SettingsConfigDict
from pydantic import Field, AliasChoices
from pathlib import Path


class Parameters(BaseSettings):
    """CLI parameters for your tool"""

    dataset_path: str = Field(
        "/in/pc_standardized.laz",
        description="Input dataset path",
        alias=AliasChoices("dataset-path", "dataset_path"),
    )
    output_dir: Path = Field(
        "/out",
        description="Output directory",
        alias=AliasChoices("output-dir", "output_dir"),
    )
    tile_size: int = Field(
        50,
        description="Tile size",
        alias=AliasChoices("tile-size", "tile_size"),
    )
    overlap: int = Field(
        20,
        description="Overlap",
        alias=AliasChoices("overlap", "overlap"),
    )

    task: str = Field(
        "tile",
        description="Task to perform: Tile includes subsampling; Merge includes merging the tiles back and mapping to original resolution.",
    )

    model_config = SettingsConfigDict(
        case_sensitive=False, cli_parse_args=True, cli_ignore_unknown_args=True
    )
