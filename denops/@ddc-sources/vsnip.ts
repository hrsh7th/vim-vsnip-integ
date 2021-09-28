import {
  BaseSource,
  Candidate,
} from "https://deno.land/x/ddc_vim@v0.14.0/types.ts#^";
import { Denops, fn } from "https://deno.land/x/ddc_vim@v0.14.0/deps.ts#^";

type Params = Record<string, never>;

export class Source extends BaseSource<Params> {
  async gatherCandidates(args: {
    denops: Denops;
  }): Promise<Candidate[]> {
    return args.denops.call(
      "vsnip#get_complete_items",
      await fn.bufnr(args.denops),
    ) as Promise<Candidate[]>;
  }

  params(): Params {
    return {};
  }
}
