import {
  BaseSource,
  Candidate,
} from "https://deno.land/x/ddc_vim@v0.5.0/types.ts";
import { Denops, fn } from "https://deno.land/x/ddc_vim@v0.5.0/deps.ts#^";

export class Source extends BaseSource {
  async gatherCandidates(args: {
    denops: Denops;
  }): Promise<Candidate[]> {
    return args.denops.call(
      "vsnip#get_complete_items",
      await fn.bufnr(args.denops),
    ) as Promise<Candidate[]>;
  }
}
