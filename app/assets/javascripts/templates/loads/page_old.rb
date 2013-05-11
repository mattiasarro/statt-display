<div class="loads">
  {{#each loadColumnsWithIndices}}
    <div {{bindAttr class=":loads-col first:loads-col-first"}}>
      {{#each this.item}}
        {{view Statt.LoadView}}
      {{/each}}
    </div>
  {{/each}}
</div>