///|
fn moontown_request_mapper_js() -> String {
  "  __moontownRuntimeProjection(){\n" +
  "    const a=this.data.activationResult||{},o=this.data.onboardingSnapshot||{},profile=o.profile||a.profile||{},activation=o.activation||a.activation||{}\n" +
  "    const results=[this.data.supervisorMessageResult||{},this.data.delegateResult||{},this.data.steerResult||{},this.data.supervisorWakeResult||{},this.data.supervisorStopResult||{},this.data.supervisorResumeResult||{},this.data.childSteerResult||{},this.data.cancelResult||{},this.data.retryResult||{},this.data.bookkeeperReviewResult||{}]\n" +
  "    const value=(sources,camel,snake)=>{for(const s of sources){const v=s&&s[camel]!==undefined?s[camel]:s&&s[snake];if(v!==undefined&&v!==null&&v!=='')return v}return undefined}\n" +
  "    const townCursor=Math.max(0,...[o,a,...results].map(item=>Number(item.cursor||0)))\n" +
  "    const bindings=profile.bindings||{},lineage=Array.isArray(o.executionLineage)?o.executionLineage:[]\n" +
  "    return {activeRunId:value([profile,o,activation,a],'activeRunId','active_run_id')||'',runtimeCursor:Number(value([profile,o,activation],'runtimeCursor','runtime_cursor')||0),runtimeExecutionStatus:value([profile,o,activation],'runtimeExecutionStatus','runtime_execution_status')||'',townCursor,profileId:profile.profileId||profile.profile_id||'',profileVersion:Number(profile.revision||profile.profileVersion||profile.profile_version||0),workspaceId:bindings.workspaceId||bindings.workspace_id||'',buildingId:bindings.buildingId||bindings.building_id||'',bookId:(bindings.bookIds||bindings.book_ids||[])[0]||'',executionLineage:lineage}\n" +
  "  },\n" +
  "  __moontownCommandBase(prefix,live){return {commandId:prefix+'-'+Date.now(),parentRunId:live.activeRunId,expectedCursor:live.townCursor,runtimeExpectedCursor:live.runtimeCursor,expectedVersion:live.profileVersion}} ,\n" +
  "  __bunniaMapRequest(endpointId,payload){\n" +
  "    const p=payload||{}\n" +
  "    const marketplace=this.__moontownMapMarketplaceRequest(endpointId,p);if(marketplace!==undefined)return marketplace\n" +
  "    if(endpointId==='save-supervisor-draft'){const current=this.__moontownRuntimeProjection(),catalog=this.data.installedBookCatalog||{},books=Array.isArray(catalog.books)?catalog.books:[];if(catalog.state!=='ready'||!p.bookId||!books.some(book=>book.id===p.bookId))throw new Error('Select a currently installed MoonBook');return {\n" +
  "      commandId:'save-supervisor-draft-'+Date.now(),expectedVersion:current.profileVersion,expectedCursor:current.townCursor,profileId:p.profileId,\n" +
  "      persona:{displayName:p.name,avatarUrl:p.avatarRef,role:p.archetypeId,mission:p.mission,tone:p.toneId,capabilities:p.capabilityIds||[],authorityCeiling:typeof p.authorityCeiling==='string'?p.authorityCeiling:'request_bookkeeper_review'},\n" +
  "      bindings:{workspaceId:p.bookId,buildingId:p.bookId,bookIds:[p.bookId],maxActiveWorkers:3},\n" +
  "      consents:{termsVersion:p.termsVersion||'2026-08',profileActivation:!!p.consentTermsAccepted,runtimeDelegation:!!p.consentAgentControl,bookkeeperReview:!!p.consentBookkeeperReview}\n" +
  "    }}\n" +
  "    const live=this.__moontownRuntimeProjection()\n" +
  "    if(endpointId==='activate-supervisor')return {commandId:'activate-supervisor-'+Date.now(),expectedVersion:live.profileVersion||Number(p.expectedVersion||p.profile_version||0),expectedCursor:live.townCursor||Number(p.expectedCursor||p.expected_cursor||0),runtimeExpectedCursor:live.runtimeCursor||undefined}\n" +
  "    if(endpointId==='send-supervisor-message'||endpointId==='steer-run'||endpointId==='assign-worker'){\n" +
  "      if(live.activeRunId&&live.runtimeCursor>0&&live.townCursor>0&&live.profileVersion>0){\n" +
  "        const base=this.__moontownCommandBase(endpointId,live),instruction=String(p.body||p.message||p.guidance||p.instruction||(this.data.supervisorMessage&&this.data.supervisorMessage.body)||'').trim()\n" +
  "        if(endpointId==='send-supervisor-message')return {...base,action:'message',targetRunId:live.activeRunId,instruction}\n" +
  "        if(endpointId==='steer-run')return {...base,action:'steer',targetRunId:live.activeRunId,instruction}\n" +
  "        const bookId=live.bookId||'',workspaceId=live.workspaceId||'',buildingId=live.buildingId||'',taskId=base.commandId.replace('assign-worker','task');if(!/^[a-z0-9]+(?:-[a-z0-9]+)*$/.test(bookId))throw new Error('The bound MoonBook identity is not canonical')\n" +
  "        return {...base,action:'delegate',instruction,task:{taskId,conversationId:live.activeRunId,title:instruction.slice(0,96)||'Bounded worker assignment',cwd:'',model:'gpt-5.6-sol',webSearch:false,metadata:{workspace_id:workspaceId,building_id:buildingId,book_id:bookId}},scope:{claimCeiling:'reviewable',budget:{maxCostMicroUsd:2000000,maxRuntimeMs:300000,maxTokens:12000,maxArtifacts:3},artifactPrefixes:['books/'+bookId+'/artifacts'],expiresAt:new Date(Date.now()+300000).toISOString().replace(/\\.\\d{3}Z$/,'Z')}}\n" +
  "      }\n" +
  "    }\n" +
  "    if(endpointId==='wake-supervisor'||endpointId==='stop-supervisor'||endpointId==='resume-supervisor'){\n" +
  "      if(!live.activeRunId||live.runtimeCursor<=0||live.townCursor<=0||live.profileVersion<=0)throw new Error('Refresh the receipt-backed supervisor before controlling it')\n" +
  "      const base=this.__moontownCommandBase(endpointId,live),action=endpointId==='wake-supervisor'?'wake':endpointId==='stop-supervisor'?'supervisor_stop':'supervisor_resume',instruction=endpointId==='stop-supervisor'?String(p.reason||p.instruction||'').trim():''\n" +
  "      return {...base,action,targetRunId:live.activeRunId,instruction}\n" +
  "    }\n" +
  "    if(endpointId==='steer-child-run'||endpointId==='cancel-run'||endpointId==='retry-run'){\n" +
  "      const selected=String(p.runId||'')\n" +
  "      const child=live.executionLineage.find(item=>(item.workerRunId||item.worker_run_id||item.runId||item.run_id)===selected&&(item.parentRunId||item.parent_run_id)===live.activeRunId)\n" +
  "      if(!child)throw new Error('Select a receipt-backed child run before controlling it')\n" +
  "      const base=this.__moontownCommandBase(endpointId,live),action=endpointId==='steer-child-run'?'child_steer':endpointId==='cancel-run'?'child_stop':'child_retry'\n" +
  "      return {...base,action,targetRunId:selected,instruction:action==='child_steer'?String(p.guidance||p.instruction||(this.data.runSteer&&this.data.runSteer.guidance)||'').trim():''}\n" +
  "    }\n" +
  "    if(endpointId==='request-bookkeeper-review'){\n" +
  "      const runId=String(p.runId||''),child=live.executionLineage.find(item=>(item.workerRunId||item.worker_run_id||item.runId||item.run_id)===runId&&(item.parentRunId||item.parent_run_id)===live.activeRunId),evidenceStatus=child&&(child.outcomeEvidenceStatus||child.outcome_evidence_status),submission=child&&(child.outcomeSubmission||child.outcome_evidence_candidate),record=submission&&submission.submission,refs=submission&&submission.evidence_refs\n" +
  "      if(!child||evidenceStatus!=='review_ready'||!submission||submission.contract_version!=='moonbook.bookkeeper.product_outcome_submission.v1'||submission.source_product!=='moonclaw'||!record||!record.record_id||!record.record_version||!record.record_digest||!Array.isArray(refs)||!refs.length||refs.some(ref=>!ref.reference_id||!ref.reference_version||!ref.digest||!ref.provenance_ref))throw new Error('Outcome evidence still required')\n" +
  "      return {commandId:'request-bookkeeper-review-'+Date.now(),runId,decision:'request_review',summary:String(p.summary||child.summary||'Review the exact MoonClaw outcome evidence.'),expectedCursor:live.townCursor,outcomeSubmission:submission}\n" +
  "    }\n" +
  "    return p\n" +
  "  },\n"
}

///|
fn moontown_route_page_methods_js(tab_id : String) -> String {
  let supervisor_page = tab_id == "messages" || tab_id == "home"
  let marketplace_load = if tab_id == "discover" {
    "    this.setData({'ui.feedback':'marketplace-feed'});__bunniaRequest(this,'load-marketplace-feed',{q:String(this.data.marketplaceSearch&&this.data.marketplaceSearch.q||'')})\n"
  } else if tab_id == "messages" {
    "    this.setData({'ui.feedback':'channels'});__bunniaRequest(this,'load-marketplace-channels',{},()=>{this.setData({'ui.feedback':'notifications'});__bunniaRequest(this,'load-marketplace-notifications',{})})\n"
  } else {
    ""
  }
  let marketplace_response = if supervisor_page {
    ""
  } else {
    "  __bunniaResponsePatch(endpointId,data){return this.__moontownSharedResponsePatch(endpointId,data)||{}},\n"
  }
  let load_supervisor = if supervisor_page {
    if tab_id == "home" {
      "    this.__moontownLoadBookCatalog(()=>this.__moontownRefreshSupervisor(12,2))\n"
    } else {
      "    this.__moontownRefreshSupervisor(12,2)\n"
    }
  } else {
    ""
  }
  let supervisor_methods = if supervisor_page {
    moontown_supervisor_lifecycle_methods_js(tab_id == "home")
  } else {
    ""
  }
  "  onLoad(options){\n" +
  "    this.__mtPageHidden=false\n" +
  "    if(options&&options.buildingId)this.setData({'town.selectedBuildingId':options.buildingId,'town.detailsOpen':false})\n" +
  "    if(options&&options.channel)this.setData({'messages.channel':options.channel})\n" +
  load_supervisor +
  marketplace_load +
  "  },\n" +
  marketplace_response +
  supervisor_methods
}

///|
fn moontown_supervisor_lifecycle_methods_js(load_book_catalog : Bool) -> String {
  let page_shown = if load_book_catalog {
    "  __bunniaPageShown(){this.__mtPageHidden=false;this.__moontownLoadBookCatalog(()=>this.__moontownRefreshSupervisor(8,1))},\n"
  } else {
    "  __bunniaPageShown(){this.__mtPageHidden=false;this.__moontownRefreshSupervisor(8,1)},\n"
  }
  let catalog_preflight = if load_book_catalog {
    "const beforeSupervisor=(next)=>__bunniaRequest(this,'load-book-registrations',{},(catalogOk)=>{if(catalogOk)next();else{this.__mtCommandPreflight=false;this.setData({'supervisorSetup.state':'error'})}});"
  } else {
    "const beforeSupervisor=(next)=>next();"
  }
  page_shown +
  "  onHide(){this.__mtPageHidden=true;if(this.__mtSupervisorTimer){clearTimeout(this.__mtSupervisorTimer);this.__mtSupervisorTimer=null}},\n" +
  "  onUnload(){this.__mtPageHidden=true;if(this.__mtSupervisorTimer){clearTimeout(this.__mtSupervisorTimer);this.__mtSupervisorTimer=null}},\n" +
  "  __moontownLoadBookCatalog(done){__bunniaRequest(this,'load-book-registrations',{},(ok,data)=>{if(typeof done==='function')done(ok,data)})},\n" +
  "  __bunniaResponsePatch(endpointId,data){\n" +
  "    const marketplace=this.__moontownSharedResponsePatch(endpointId,data);if(marketplace)return marketplace\n" +
  "    if(endpointId==='load-book-registrations'){const source=data&&Array.isArray(data.books)?data.books:[],books=source.filter(item=>item&&typeof item.id==='string'&&item.id).map(item=>({id:item.id,name:String(item.name||item.id),purpose:String(item.purpose||'')})),draft=this.data.supervisorDraft||{},current=String(draft.bookId||''),selected=books.some(item=>item.id===current)?current:(books[0]&&books[0].id||'');return {'installedBookCatalog.state':'ready','installedBookCatalog.books':books,'supervisorDraft.bookId':selected,'supervisorDraft.workspaceId':selected,'supervisorDraft.buildingId':selected}}\n" +
  "    if(!['load-supervisor-setup','save-supervisor-draft','activate-supervisor'].includes(endpointId)||!data)return {}\n" +
  "    const profile=data.profile||{},identity=profile.identity||{},bindings=profile.bindings||{},consent=profile.consent||{},readiness=data.readiness||{},activation=data.activation||{},draft=this.data.supervisorDraft||{},setup=this.data.supervisorSetup||{},profileId=profile.profileId||profile.profile_id||'',bookIds=bindings.bookIds||bindings.book_ids||[],catalog=this.data.installedBookCatalog||{},books=Array.isArray(catalog.books)?catalog.books:[],rawBook=bookIds[0]||'',bookId=catalog.state==='ready'&&!books.some(item=>item.id===rawBook)?'':rawBook,runtimeStatus=activation.status||readiness.state||'not_started',activeRunId=profile.activeRunId||profile.active_run_id||data.activeRunId||data.active_run_id||'',hasProfile=!!profileId,activated=!!activeRunId||runtimeStatus==='runtime_acknowledged'||runtimeStatus==='active',lineage=Array.isArray(data.executionLineage)?data.executionLineage:[],activeWorkers=lineage.filter(item=>(item.workerRunId||item.worker_run_id)&&['pending_provider','running','waiting_for_input'].includes(item.runtimeExecutionStatus||item.runtime_execution_status||item.status)).length,maxWorkers=Number(bindings.maxActiveWorkers||bindings.max_active_workers||3)\n" +
  "    const patch={'supervisorSetup.state':hasProfile?(activated?'active':'saved'):'empty','supervisorSetup.currentStep':hasProfile?(activated?'activate':(setup.currentStep||'identity')):'identity','supervisorSetup.activated':activated,'supervisorSetup.runtimeStatus':runtimeStatus,'supervisorSetup.bookkeeperStatus':data.pendingHumanGate||data.pending_human_gate||'not_requested','supervisorDraft.expectedCursor':Number(data.cursor||0),'supervisorRuntime.activeWorkerCount':activeWorkers,'supervisorRuntime.workerHistoryCount':lineage.length,'supervisorRuntime.maxActiveWorkers':maxWorkers}\n" +
  "    if(hasProfile)Object.assign(patch,{'supervisorDraft.profileId':profileId,'supervisorDraft.version':Number(profile.revision||0),'supervisorDraft.expectedVersion':Number(profile.revision||0),'supervisorDraft.name':identity.displayName||identity.display_name||'','supervisorDraft.avatarRef':identity.avatarUrl||identity.avatar_url||'','supervisorDraft.archetypeId':profile.role||'','supervisorDraft.mission':profile.mission||'','supervisorDraft.toneId':profile.tone||'','supervisorDraft.capabilityIds':Array.isArray(profile.capabilities)?profile.capabilities:[],'supervisorDraft.workspaceId':bookId?(bindings.workspaceId||bindings.workspace_id||bookId):'','supervisorDraft.buildingId':bookId?(bindings.buildingId||bindings.building_id||bookId):'','supervisorDraft.bookId':bookId,'supervisorDraft.maxActiveWorkers':Number(bindings.maxActiveWorkers||bindings.max_active_workers||3),'supervisorDraft.model':'gpt-5.6-sol','supervisorDraft.consentAgentControl':!!(consent.runtimeDelegation||consent.runtime_delegation),'supervisorDraft.consentBookkeeperReview':!!(consent.bookkeeperReview||consent.bookkeeper_review),'supervisorDraft.consentTermsAccepted':!!(consent.profileActivation||consent.profile_activation),'supervisorDraft.termsVersion':consent.termsVersion||consent.terms_version||'2026-08','supervisorDraft.authorityCeiling':profile.authorityCeiling||profile.authority_ceiling||'request_bookkeeper_review'})\n" +
  "    const history=Array.isArray(data.conversationHistory)?data.conversationHistory:[],lastUser=[...history].reverse().find(item=>item&&item.role==='user'),draftBody=String(this.data.supervisorMessage&&this.data.supervisorMessage.body||'').trim();if(lastUser&&draftBody&&String(lastUser.content||'').trim()===draftBody)patch['supervisorMessage.body']=''\n" +
  "    return patch\n" +
  "  },\n" +
  "  __moontownRuntimePending(){const o=this.data.onboardingSnapshot||{},a=this.data.activationResult||{},activation=o.activation||a.activation||{},statuses=[activation.status,this.data.supervisorMessageResult&&this.data.supervisorMessageResult.status,this.data.delegateResult&&this.data.delegateResult.status,this.data.steerResult&&this.data.steerResult.status,this.data.supervisorWakeResult&&this.data.supervisorWakeResult.status,this.data.supervisorStopResult&&this.data.supervisorStopResult.status,this.data.supervisorResumeResult&&this.data.supervisorResumeResult.status,this.data.childSteerResult&&this.data.childSteerResult.status,this.data.cancelResult&&this.data.cancelResult.status,this.data.retryResult&&this.data.retryResult.status],pending=statuses.some(value=>value==='pending_transport'||value==='claimed_for_transport'||value==='assigned');const lineage=Array.isArray(o.executionLineage)?o.executionLineage:[];return pending||lineage.some(item=>{const state=item.runtimeExecutionStatus||item.runtime_execution_status||item.status;return state==='pending_provider'||state==='running'||state==='waiting_for_input'})},\n" +
  "  __moontownRefreshSupervisor(remaining,minimum){if(this.__mtPageHidden||remaining<=0)return;if(this.__mtSupervisorTimer){clearTimeout(this.__mtSupervisorTimer);this.__mtSupervisorTimer=null}__bunniaRequest(this,'load-supervisor-setup',{},(ok)=>{if(!ok||this.__mtPageHidden)return;const must=Number(minimum||0)>1;if(must||this.__moontownRuntimePending())this.__mtSupervisorTimer=setTimeout(()=>this.__moontownRefreshSupervisor(remaining-1,Math.max(0,Number(minimum||0)-1)),900)})},\n" +
  "  __bunniaBeforeRequest(endpointId,payload,send){const guarded=['save-supervisor-draft','activate-supervisor','send-supervisor-message','assign-worker','steer-run','wake-supervisor','stop-supervisor','resume-supervisor','steer-child-run','cancel-run','retry-run','request-bookkeeper-review'];if(!guarded.includes(endpointId))return false;if(this.__mtCommandPreflight)return true;this.__mtCommandPreflight=true;" +
  catalog_preflight +
  "beforeSupervisor(()=>__bunniaRequest(this,'load-supervisor-setup',{},(ok)=>{this.__mtCommandPreflight=false;if(!ok)return;send();this.__moontownRefreshSupervisor(15,3)}));return true},\n"
}
