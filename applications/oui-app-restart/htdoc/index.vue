<template>
   <n-card :title="$t('system')">
    <n-tabs default-value="r1" size="large" justify-content="space-evenly">
      <n-tab-pane name="r1" :tab="$t('restart1')">
        <br>
        <br>
        <n-space justify="end" style="padding-right: 100px">
          <n-button type="primary"  @click="showAdd">{{ $t('restart1') }}</n-button>
        </n-space>
      </n-tab-pane>

      <n-tab-pane name="r2" :tab="$t('restart2')">
        <br>
        <br>
        <n-radio-group v-model:value="myflag">
          <n-space style="padding-left: 150px">
            <n-radio :label="$t('close')" value="0" />
            <n-radio :label="$t('every day')" value="1" />
            <n-radio :label="$t('every week')" value="2" />
          </n-space>
        </n-radio-group>
        <n-space justify="end" style="padding-right: 100px">
          <n-button type="primary"  @click="showAdd">{{ $t('save') }}</n-button>
        </n-space>
      </n-tab-pane>

    </n-tabs>
  </n-card>
</template>
<style>
export default {
  data() {
    return {
      myflag: '1'
    }
  }
}
</style>
<i18n src="./locale.json"/>
