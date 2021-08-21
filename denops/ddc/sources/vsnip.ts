import {
  BaseSource,
  Candidate,
  Context,
  DdcOptions,
  SourceOptions,
} from "https://deno.land/x/ddc_vim@v0.0.13/types.ts";
import { Denops, fn } from "https://deno.land/x/ddc_vim@v0.0.13/deps.ts#^";

export class Source extends BaseSource {
  async gatherCandidates(
    denops: Denops,
    _context: Context,
    _ddcOptions: DdcOptions,
    _sourceOptions: SourceOptions,
    _sourceParams: Record<string, unknown>,
    _completeStr: string,
  ): Promise<Candidate[]> {
    return denops.call(
      "vsnip#get_complete_items",
      await fn.bufnr(denops),
    );
  }
}
