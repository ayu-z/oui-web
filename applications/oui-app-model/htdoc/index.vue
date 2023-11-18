<template>
  <n-card :title="$t('general information')">
    <n-table :bordered="false" :single-line="false">
    <thead>
      <tr>
        <th>{{ $t('mod') }}</th>
        <th>{{ $t('manuf') }}</th>
        <th>{{ $t('update') }}</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>{{modle}}</td>
        <td>{{manu}}</td>
        <td>{{update}}</td>
      </tr>
    </tbody>
  </n-table>
  </n-card>
  <n-card :title="$t('modem')">
    <n-table :bordered="false" :single-line="false">
    <thead>
      <tr>
        <th>{{ $t('card slot') }}</th>
        <th>{{ $t('operator') }}</th>
        <th>{{ $t('imei') }}</th>
        <th>{{ $t('imsi') }}</th>
        <th>{{ $t('iccid') }}</th>
        <th>{{ $t('sim number') }}</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>{{card}}</td>
        <td>{{oper}}</td>
        <td>{{imei}}</td>
        <td>{{imsi}}</td>
        <td>{{iccid}}</td>
        <td>{{sim}}</td>
      </tr>
    </tbody>
  </n-table>
  </n-card>
  <n-card :title="$t('signal status')">
    <n-table :bordered="false" :single-line="false">
    <thead>
      <tr>
        <th>{{ $t('cellular network type') }}</th>
        <th>{{ $t('csq') }}</th>
        <th>{{ $t('signal strength') }}</th>
        <th>{{ $t('reception strength') }}</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td>{{cellular}}</td>
        <td>{{csq}}</td>
        <td>{{signal}}%</td>
        <td>{{reception}}dBm</td>
      </tr>
    </tbody>
  </n-table>
  </n-card>
</template>
<script>

export default {
  data() {
    return {
      modle: 'SLM750A',
      manu: '美格',
      update: '2023.10.23',
      card: 'N/A',
      oper: 'CHN-UNICOM',
      imei: '863632321516',
      imsi: '862231215151',
      iccid: '648451231215',
      sim: '14707028286',
      cellular: '4G',
      csq: '25',
      signal: '80',
      reception: '-63'
    }
  }
}
</script>
<i18n src="./locale.json"/>
